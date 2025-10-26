import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/services/ai_service.dart';
import 'package:ai_organizer/data/models/attachment.dart' as model;
import 'package:ai_organizer/utils/file_utils.dart';
import 'package:uuid/uuid.dart';

/// Screen for recording voice notes with transcription
class VoiceNoteScreen extends ConsumerStatefulWidget {
  const VoiceNoteScreen({super.key});

  @override
  ConsumerState<VoiceNoteScreen> createState() => _VoiceNoteScreenState();
}

class _VoiceNoteScreenState extends ConsumerState<VoiceNoteScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _transcriptionController = TextEditingController();

  bool _isRecording = false;
  bool _isPaused = false;
  bool _hasRecording = false;
  bool _isPlaying = false;
  bool _isTranscribing = false;
  bool _isSaving = false;
  bool _isEditingTranscription = false;
  String _recordingPath = '';
  String _transcription = '';
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Duration? _audioFileDuration;
  Timer? _recordingTimer;
  final AIService _aiService = AIService();

  // Animation controller for pulsing mic icon
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _checkPermissions();

    // Setup pulse animation for recording
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Listen to playback position changes
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _playbackPosition = position;
        });
      }
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _audioFileDuration = duration;
        });
      }
    });

    // Listen to playback completion
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playbackPosition = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
    _titleController.dispose();
    _transcriptionController.dispose();
    _recordingTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      if (mounted) {
        _showSnackBar(
          'Microphone permission is required to record audio.',
          isError: true,
        );
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      // Create a unique file name with timestamp
      final now = DateTime.now();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
      final directory = await getTemporaryDirectory();
      _recordingPath = '${directory.path}/voice_note_$timestamp.m4a';

      // Configure recording
      const config = RecordConfig();

      // Start recording
      await _recorder.start(config, path: _recordingPath);

      setState(() {
        _isRecording = true;
        _isPaused = false;
        _recordingDuration = Duration.zero;
      });

      // Start timer to track recording duration
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration += const Duration(seconds: 1);
          });
        }
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _showSnackBar('Failed to start recording.', isError: true);
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _recorder.pause();
      setState(() {
        _isPaused = true;
      });
      _recordingTimer?.cancel();
    } catch (e) {
      debugPrint('Error pausing recording: $e');
      _showSnackBar('Failed to pause recording: $e', isError: true);
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _recorder.resume();
      setState(() {
        _isPaused = false;
      });
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration += const Duration(seconds: 1);
          });
        }
      });
    } catch (e) {
      debugPrint('Error resuming recording: $e');
      _showSnackBar('Failed to resume recording: $e', isError: true);
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      if (path != null) {
        setState(() {
          _isRecording = false;
          _isPaused = false;
          _hasRecording = true;
          _recordingPath = path;
        });
        _recordingTimer?.cancel();
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _showSnackBar('Failed to stop recording: $e', isError: true);
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath.isEmpty) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.setSourceDeviceFile(_recordingPath);
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Error playing recording: $e');
    }
  }

  Future<void> _transcribeRecording() async {
    if (_recordingPath.isEmpty) return;

    setState(() {
      _isTranscribing = true;
    });

    try {
      final result = await _aiService.transcribeAudio(_recordingPath);
      if (mounted) {
        setState(() {
          _transcription = result;
          _transcriptionController.text = result;
          _isTranscribing = false;
        });
      }
    } catch (e) {
      debugPrint('Error transcribing recording: $e');
      if (mounted) {
        setState(() {
          _isTranscribing = false;
        });
        _showSnackBar('Failed to transcribe audio: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _saveVoiceNote() async {
    // Validation
    if (_recordingPath.isEmpty) {
      _showSnackBar('No recording to save.', isError: true);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Generate title
      final title = _titleController.text.isNotEmpty
          ? _titleController.text
          : 'Voice Note ${DateFormat('MMM d, yyyy HH:mm').format(DateTime.now())}';

      // Get transcription (edited or original)
      final content = _isEditingTranscription
          ? _transcriptionController.text
          : (_transcription.isNotEmpty
              ? _transcription
              : 'Voice recording (not yet transcribed)');

      // Create the note first
      final notesActions = ref.read(notesActionsProvider);
      final createdNote = await notesActions.createNote(
        title: title,
        content: content,
        tags: ['voice_note'],
      );

      // Save audio file as attachment
      final audioFile = File(_recordingPath);
      if (await audioFile.exists()) {
        // Copy to permanent location
        final appDir = await getApplicationDocumentsDirectory();
        final permanentPath =
            '${appDir.path}/voice_notes/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final permanentDir = Directory('${appDir.path}/voice_notes');

        // Create directory if it doesn't exist
        if (!await permanentDir.exists()) {
          await permanentDir.create(recursive: true);
        }

        // Copy file
        await audioFile.copy(permanentPath);

        // Create attachment model
        final noteRepository = ref.read(noteRepositoryProvider);
        final attachment = model.Attachment(
          id: const Uuid().v4(),
          noteId: createdNote.id,
          fileName: '${title.replaceAll(RegExp(r'[^\w\s-]'), '_')}.m4a',
          filePath: permanentPath,
          fileSize: await audioFile.length(),
          type: model.AttachmentType.audio,
          createdAt: DateTime.now(),
          mimeType: FileUtils.getMimeType(permanentPath),
          thumbnailPath: null,
        );

        // Add attachment to note
        await noteRepository.addAttachment(attachment);
      }

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        _showSnackBar('Voice note saved successfully!');

        // Navigate back to the notes list
        context.go('/notes');
      }
    } catch (e) {
      debugPrint('Error saving voice note: $e');
      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        _showSnackBar('Failed to save voice note: ${e.toString()}', isError: true);
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('capture.voiceNote'.tr()),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          if (_hasRecording && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveVoiceNote,
              tooltip: 'Save voice note',
            ),
          if (_isSaving)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.screenVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recording visualization card
            _buildRecordingVisualizationCard(colorScheme, textTheme),

            const SizedBox(height: AppSpacing.xl),

            // Recording controls
            if (_isRecording) _buildRecordingControls(colorScheme, textTheme),

            // Post-recording UI
            if (_hasRecording && !_isRecording) ...[
              const SizedBox(height: AppSpacing.xl),

              // Title input
              _buildTitleInput(colorScheme, textTheme),

              const SizedBox(height: AppSpacing.xl),

              // Transcription section
              _buildTranscriptionSection(colorScheme, textTheme),
            ],
          ],
        ),
      ),
      floatingActionButton: !_isRecording && !_hasRecording
          ? _buildRecordButton(colorScheme)
          : null,
    );
  }

  Widget _buildRecordingVisualizationCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: SizedBox(
        height: 220,
        child: _isRecording
            ? _buildRecordingState(colorScheme, textTheme)
            : _hasRecording
                ? _buildRecordedState(colorScheme, textTheme)
                : _buildIdleState(colorScheme, textTheme),
      ),
    );
  }

  Widget _buildIdleState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mic_none,
          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          size: 80,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Tap the mic button to start recording',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecordingState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pulsing mic icon
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.mic,
              color: colorScheme.primary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _formatDuration(_recordingDuration),
          style: textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _isPaused ? 'Recording paused' : 'Recording...',
          style: textTheme.bodyLarge?.copyWith(
            color: _isPaused ? colorScheme.error : colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Simple waveform visualization
        if (!_isPaused) _WaveformVisualization(color: colorScheme.primary),
      ],
    );
  }

  Widget _buildRecordedState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Waveform visualization with playback
        Expanded(
          child: _AudioWaveformPlayer(
            duration: _recordingDuration,
            currentPosition: _playbackPosition,
            isPlaying: _isPlaying,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Playback controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause button
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: AppShadows.cardShadow,
              ),
              child: IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                color: colorScheme.onPrimary,
                iconSize: 28,
                onPressed: _playRecording,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // Duration display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDuration(_playbackPosition),
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '/ ${_formatDuration(_audioFileDuration ?? _recordingDuration)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecordingControls(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pause/Resume button
        _SecondaryButton(
          onPressed: _isPaused ? _resumeRecording : _pauseRecording,
          icon: _isPaused ? Icons.play_arrow : Icons.pause,
          label: _isPaused ? 'Resume' : 'Pause',
        ),
        const SizedBox(width: AppSpacing.md),
        // Stop button
        _PrimaryButton(
          onPressed: _stopRecording,
          icon: Icons.stop,
          label: 'Stop',
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
        ),
      ],
    );
  }

  Widget _buildTitleInput(ColorScheme colorScheme, TextTheme textTheme) {
    return _AppTextField(
      controller: _titleController,
      labelText: 'Note Title',
      hintText: 'Enter a title for your voice note',
    );
  }

  Widget _buildTranscriptionSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transcription',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (_isTranscribing)
          _buildTranscribingLoader(colorScheme, textTheme)
        else if (_transcription.isNotEmpty)
          _isEditingTranscription
              ? _buildEditTranscription(colorScheme, textTheme)
              : _buildTranscriptionCard(colorScheme, textTheme)
        else
          _buildTranscribeButton(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildTranscribingLoader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Transcribing audio...',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptionCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // AI indicator tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  border: Border.all(
                    color: colorScheme.secondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI Generated',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.edit, color: colorScheme.onSurfaceVariant),
                onPressed: () {
                  setState(() {
                    _isEditingTranscription = true;
                  });
                },
                iconSize: 20,
                tooltip: 'Edit transcription',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _transcription,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditTranscription(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AppTextField(
          controller: _transcriptionController,
          labelText: 'Transcription',
          hintText: 'Edit the transcription',
          maxLines: 8,
          minLines: 4,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _SecondaryButton(
              onPressed: () {
                setState(() {
                  _isEditingTranscription = false;
                  _transcriptionController.text = _transcription;
                });
              },
              label: 'Cancel',
            ),
            const SizedBox(width: AppSpacing.sm),
            _PrimaryButton(
              onPressed: () {
                setState(() {
                  _transcription = _transcriptionController.text;
                  _isEditingTranscription = false;
                });
              },
              label: 'Save',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTranscribeButton(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _transcribeRecording,
        icon: Icon(Icons.translate, color: colorScheme.primary),
        label: Text(
          'Transcribe recording',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordButton(ColorScheme colorScheme) {
    return FloatingActionButton(
      onPressed: _startRecording,
      tooltip: 'Start recording',
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 4,
      child: const Icon(Icons.mic, size: 28),
    );
  }
}

// Custom Waveform Visualization Widget (Animated during recording)
class _WaveformVisualization extends StatefulWidget {
  final Color color;

  const _WaveformVisualization({required this.color});

  @override
  State<_WaveformVisualization> createState() => _WaveformVisualizationState();
}

class _WaveformVisualizationState extends State<_WaveformVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 40),
          painter: _WaveformPainter(
            color: widget.color,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

// Custom Painter for Waveform
class _WaveformPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _WaveformPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final random = math.Random(42); // Fixed seed for consistent pattern
    final barCount = 40;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;
      final phase = (animationValue + i / barCount) % 1.0;
      final height = (math.sin(phase * math.pi * 2) * 0.5 + 0.5) *
          size.height *
          0.6 *
          (0.3 + random.nextDouble() * 0.7);

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}

// Audio Waveform Player (Static waveform with playback indicator)
class _AudioWaveformPlayer extends StatelessWidget {
  final Duration duration;
  final Duration currentPosition;
  final bool isPlaying;
  final Color color;

  const _AudioWaveformPlayer({
    required this.duration,
    required this.currentPosition,
    required this.isPlaying,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = duration.inMilliseconds > 0
        ? currentPosition.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return CustomPaint(
      size: const Size(double.infinity, 60),
      painter: _StaticWaveformPainter(
        color: color,
        progress: progress.clamp(0.0, 1.0),
      ),
    );
  }
}

// Static Waveform Painter with playback progress
class _StaticWaveformPainter extends CustomPainter {
  final Color color;
  final double progress;

  _StaticWaveformPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(123); // Fixed seed for consistent pattern
    final barCount = 60;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;
      final normalizedPosition = i / barCount;
      final height = size.height * 0.7 * (0.2 + random.nextDouble() * 0.8);

      final paint = Paint()
        ..color = normalizedPosition <= progress
            ? color
            : color.withOpacity(0.3)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(x, centerY - height / 2),
        Offset(x, centerY + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StaticWaveformPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

// Custom AppTextField component following UI guidelines
class _AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final int? maxLines;
  final int? minLines;

  const _AppTextField({
    this.controller,
    this.labelText,
    this.hintText,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      style: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintText: hintText,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}

// Primary Button component following UI guidelines
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const _PrimaryButton({
    required this.label,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? colorScheme.primary,
        foregroundColor: foregroundColor ?? colorScheme.onPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: foregroundColor ?? colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// Secondary Button component following UI guidelines
class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const _SecondaryButton({
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
