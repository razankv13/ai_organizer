import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/providers/database_provider.dart';
import 'package:ai_organizer/data/models/attachment.dart' as model;

/// Screen for displaying a list of all voice notes
class VoiceNotesListScreen extends ConsumerStatefulWidget {
  const VoiceNotesListScreen({super.key});

  @override
  ConsumerState<VoiceNotesListScreen> createState() =>
      _VoiceNotesListScreenState();
}

class _VoiceNotesListScreenState extends ConsumerState<VoiceNotesListScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingAttachmentId;
  bool _isPlaying = false;
  Duration _playbackPosition = Duration.zero;
  Duration? _audioFileDuration;

  @override
  void initState() {
    super.initState();

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
          _currentPlayingAttachmentId = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseAudio(model.Attachment attachment) async {
    try {
      // If currently playing this attachment, pause it
      if (_currentPlayingAttachmentId == attachment.id && _isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      // If playing a different attachment, stop it and play the new one
      if (_currentPlayingAttachmentId != attachment.id) {
        await _audioPlayer.stop();
        await _audioPlayer.setSourceDeviceFile(attachment.filePath);
        setState(() {
          _currentPlayingAttachmentId = attachment.id;
        });
      }

      // Resume playback
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play audio: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
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
    // Get theme data once at the top
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Get all notes with 'voice_note' tag
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Voice Notes',
          style: textTheme.titleLarge,
        ),
        actions: [
          Semantics(
            label: 'Record new voice note',
            child: IconButton(
              icon: const Icon(Icons.mic),
              iconSize: AppSpacing.iconSize,
              onPressed: () {
                context.push(AppRoutes.voiceNote);
              },
              tooltip: 'Record new voice note',
            ),
          ),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          // Filter notes with voice_note tag
          final voiceNotes =
              notes.where((note) => note.tags.contains('voice_note')).toList();

          if (voiceNotes.isEmpty) {
            return _buildEmptyState(context, colorScheme, textTheme);
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            itemCount: voiceNotes.length,
            itemBuilder: (context, index) {
              final note = voiceNotes[index];
              return _buildVoiceNoteCard(context, note, colorScheme, textTheme);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(
          context,
          colorScheme,
          textTheme,
          error,
        ),
      ),
    );
  }

  /// Build empty state widget following UI/UX guidelines
  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_none,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No voice notes yet',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the mic button to create your first voice note',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: AppSpacing.minTouchTarget,
              child: FilledButton.icon(
                onPressed: () {
                  context.push(AppRoutes.voiceNote);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: AppSpacing.buttonPadding,
                ),
                icon: const Icon(Icons.mic, size: AppSpacing.iconSizeSmall),
                label: Text(
                  'Record Voice Note',
                  style: textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error state widget
  Widget _buildErrorState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    Object error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Failed to load voice notes',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error.toString(),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build voice note card following UI/UX guidelines
  Widget _buildVoiceNoteCard(
    BuildContext context,
    dynamic note,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.cardMargin),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(AppRoutes.noteDetail(note.id));
          },
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          splashColor: colorScheme.onSurface.withValues(alpha: 0.06),
          highlightColor: colorScheme.onSurface.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title + Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      DateFormat('MMM d').format(note.createdAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xs),

                // Timestamp
                Text(
                  DateFormat('HH:mm').format(note.createdAt),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                // Audio attachments
                FutureBuilder<List<model.Attachment>>(
                  future: ref
                      .watch(noteRepositoryProvider)
                      .getAttachmentsForNote(note.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final audioAttachments = snapshot.data!
                        .where((attachment) =>
                            attachment.type == model.AttachmentType.audio)
                        .toList();

                    if (audioAttachments.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: audioAttachments
                          .map((attachment) => _buildAudioPlayer(
                                context,
                                attachment,
                                colorScheme,
                                textTheme,
                              ))
                          .toList(),
                    );
                  },
                ),

                // Content preview
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    note.content,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build audio player UI following UI/UX guidelines
  Widget _buildAudioPlayer(
    BuildContext context,
    model.Attachment attachment,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isCurrentlyPlaying = _currentPlayingAttachmentId == attachment.id;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              // Play button (circular, 32x32)
              Semantics(
                label: isCurrentlyPlaying && _isPlaying
                    ? 'Pause audio'
                    : 'Play audio',
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    icon: Icon(
                      isCurrentlyPlaying && _isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: colorScheme.surface,
                    ),
                    onPressed: () {
                      _playPauseAudio(attachment);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Waveform visualization
              Expanded(
                child: SizedBox(
                  height: 32,
                  child: CustomPaint(
                    painter: WaveformPainter(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      activeColor: colorScheme.primary,
                      progress: isCurrentlyPlaying && _audioFileDuration != null
                          ? _playbackPosition.inMilliseconds /
                              _audioFileDuration!.inMilliseconds
                          : 0.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Duration
              Text(
                isCurrentlyPlaying && _audioFileDuration != null
                    ? _formatDuration(_playbackPosition)
                    : _formatDuration(
                        Duration(seconds: attachment.metadata?['duration'] ?? 0),
                      ),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for audio waveform visualization
class WaveformPainter extends CustomPainter {
  final Color color;
  final Color activeColor;
  final double progress;

  WaveformPainter({
    required this.color,
    required this.activeColor,
    this.progress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Generate waveform bars with varying heights
    final barCount = 40;
    final barWidth = 2.0;
    final spacing = (size.width - (barCount * barWidth)) / (barCount - 1);

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);

      // Create varied heights for visual interest
      final heightFactor = (i % 7 == 0)
          ? 0.9
          : (i % 5 == 0)
              ? 0.7
              : (i % 3 == 0)
                  ? 0.5
                  : (i % 2 == 0)
                      ? 0.3
                      : 0.4;

      final barHeight = size.height * heightFactor;
      final y = (size.height - barHeight) / 2;

      // Determine if this bar should be highlighted based on progress
      final isActive = (i / barCount) <= progress;
      paint.color = isActive ? activeColor : color;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.activeColor != activeColor;
  }
}
