import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_organizer/core/navigation/app_routes.dart';
import 'package:ai_organizer/core/theme/app_spacing.dart';
import 'package:ai_organizer/providers/notes_provider.dart';
import 'package:ai_organizer/data/models/note.dart';
import 'package:ai_organizer/presentation/widgets/note_card.dart';
import 'package:ai_organizer/presentation/widgets/empty_state.dart';
import 'package:ai_organizer/presentation/widgets/action_sheet.dart';

/// Sort options for search results
enum SearchSortOption {
  mostRecent,
  alphabetical,
  bestMatch,
}

/// Search screen - AI-powered search functionality
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late AnimationController _clearButtonAnimationController;
  late Animation<double> _clearButtonAnimation;
  String _currentQuery = '';
  bool _isAiSearch = false;
  bool _isSearchFocused = false;
  SearchSortOption _currentSortOption = SearchSortOption.bestMatch;
  List<String> _searchHistory = [];
  final List<String> _quickSearches = [
    'notes from today',
    'pinned notes',
    'favorites',
    'archived',
    'work notes',
    'personal',
    'ideas',
    'meeting notes',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for clear button
    _clearButtonAnimationController = AnimationController(
      vsync: this,
      duration: AppSpacing.fastAnimation, // 150ms
    );

    _clearButtonAnimation = CurvedAnimation(
      parent: _clearButtonAnimationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(_onSearchChanged);

    // Listen to focus changes for border animation
    _searchFocus.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocus.hasFocus;
      });
    });

    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });

    _loadSearchHistory();
  }

  @override
  void dispose() {
    _clearButtonAnimationController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    // Animate clear button appearance
    if (query.isNotEmpty && _clearButtonAnimationController.status != AnimationStatus.completed) {
      _clearButtonAnimationController.forward();
    } else if (query.isEmpty && _clearButtonAnimationController.status != AnimationStatus.dismissed) {
      _clearButtonAnimationController.reverse();
    }

    if (query != _currentQuery) {
      setState(() {
        _currentQuery = query;
        // Check if this might be an AI search
        _isAiSearch = _currentQuery.length >= 3 && !_isSimpleQuery(_currentQuery);
      });
    }
  }

  // Same implementation as in notes_provider.dart
  bool _isSimpleQuery(String query) {
    // Check if query contains special characters that might indicate natural language
    final containsSpecialChars = RegExp(r'[?,.]').hasMatch(query);
    
    // Check if query has common natural language phrases
    final naturalLanguagePhrases = [
      'find', 'show', 'where', 'when', 'what', 'how', 'why',
      'about', 'related', 'similar', 'containing', 'today',
      'yesterday', 'week', 'month', 'from', 'with', 'without'
    ];
    
    final words = query.toLowerCase().split(' ');
    final hasNaturalLanguage = words.any((word) => 
      naturalLanguagePhrases.contains(word)
    );
    
    return !containsSpecialChars && !hasNaturalLanguage;
  }

  void _loadSearchHistory() {
    // TODO: Load from local storage
    setState(() {
      _searchHistory = [
        'flutter development',
        'project ideas',
        'meeting notes',
        'ui design',
        'task management',
      ];
    });
  }

  void _addToSearchHistory(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.take(10).toList();
        }
      });
      // TODO: Save to local storage
    }
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _addToSearchHistory(query);
      _searchController.text = query;
      setState(() {
        _currentQuery = query;
        _isAiSearch = query.length >= 3 && !_isSimpleQuery(query);
      });
    }
  }

  /// Sort notes based on the current sort option
  List<Note> _sortNotes(List<Note> notes) {
    final sortedNotes = List<Note>.from(notes);

    switch (_currentSortOption) {
      case SearchSortOption.mostRecent:
        // Sort by updated date (most recent first)
        sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;

      case SearchSortOption.alphabetical:
        // Sort alphabetically by title (case-insensitive)
        sortedNotes.sort((a, b) {
          final titleA = a.title.toLowerCase();
          final titleB = b.title.toLowerCase();
          // Handle untitled notes - put them at the end
          if (titleA.isEmpty && titleB.isEmpty) return 0;
          if (titleA.isEmpty) return 1;
          if (titleB.isEmpty) return -1;
          return titleA.compareTo(titleB);
        });
        break;

      case SearchSortOption.bestMatch:
        // Keep original order (relevance from search provider)
        // The search provider already returns results sorted by relevance
        break;
    }

    return sortedNotes;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Use advanced search provider instead of regular search
    final searchAsync = _currentQuery.isNotEmpty
        ? ref.watch(advancedSearchProvider(_currentQuery))
        : null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: AnimatedContainer(
          duration: AppSpacing.fastAnimation, // 150ms smooth transition
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: _isSearchFocused ? colorScheme.primary : colorScheme.outlineVariant,
              width: _isSearchFocused ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            decoration: InputDecoration(
              hintText: 'search.placeholder'.tr(),
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              prefixIcon: Semantics(
                label: 'Search icon',
                child: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                ),
              ),
              // Animated clear button with proper touch target
              suffixIcon: FadeTransition(
                opacity: _clearButtonAnimation,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  iconSize: 20,
                  color: colorScheme.onSurfaceVariant,
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _currentQuery = '');
                    _searchFocus.requestFocus();
                  },
                  // Ensure minimum touch target
                  constraints: const BoxConstraints(
                    minWidth: AppSpacing.minTouchTarget,
                    minHeight: AppSpacing.minTouchTarget,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w400,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                _performSearch(query);
              }
            },
          ),
        ),
        actions: [
          // Show AI icon when using AI search
          if (_isAiSearch && _currentQuery.isNotEmpty) ...[
            Semantics(
              label: 'AI-powered search active',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(
                  Icons.auto_awesome,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.tune),
            iconSize: 22,
            onPressed: () => _showSearchFilters(context),
            tooltip: 'Search filters',
            // Ensure minimum touch target
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search type indicator
          if (_currentQuery.isNotEmpty && _isAiSearch) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xs,
                horizontal: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border(
                  top: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                  bottom: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'AI-Powered Search',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Quick search suggestions bar
          if (_currentQuery.isEmpty) _buildQuickSearchBar(context),
          
          // Search results or suggestions
          Expanded(
            child: _currentQuery.isEmpty
                ? _buildSearchSuggestions(context)
                : (searchAsync == null 
                  ? const SizedBox() 
                  : searchAsync.when(
                      data: (notes) {
                        if (notes.isEmpty) {
                          return _buildNoResultsState(context);
                        }
                        return _buildSearchResults(context, notes);
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text('Error: $error'),
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Search',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickSearches.map((search) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _performSearch(search),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      splashColor: colorScheme.primary.withValues(alpha: 0.1),
                      highlightColor: colorScheme.primary.withValues(alpha: 0.05),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusXs),
                        ),
                        child: Text(
                          search,
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search history
          if (_searchHistory.isNotEmpty) ...[
            _buildSectionHeader(context, 'Recent Searches', Icons.history),
            const SizedBox(height: AppSpacing.sm),
            ..._searchHistory
                .take(5)
                .map((query) => _buildHistoryItem(context, query)),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Search tips
          _buildSectionHeader(context, 'Search Tips', Icons.lightbulb_outline),
          const SizedBox(height: AppSpacing.sm),
          _buildSearchTip(
              context, 'Search by content', 'Type any word or phrase from your notes'),
          _buildSearchTip(context, 'Search by tags',
              'Use # followed by tag name (e.g., #work)'),
          _buildSearchTip(context, 'Search by status',
              'Try "pinned", "favorites", or "archived"'),
          _buildSearchTip(context, 'Search by date',
              'Use "today", "yesterday", or "this week"'),

          const SizedBox(height: AppSpacing.xl),

          // AI search preview - Clean card design with proper theming
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
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
                    Icon(
                      Icons.auto_awesome,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'AI-Powered Search',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Enhanced search capabilities coming soon:',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...[
                  '• Natural language queries',
                  '• Semantic search and similarity',
                  '• OCR text recognition in images',
                  '• Related notes suggestions',
                ].map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Text(
                        feature,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, String query) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.history,
        color: colorScheme.onSurfaceVariant,
        size: 20,
      ),
      title: Text(
        query,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.arrow_outward,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        onPressed: () => _performSearch(query),
        tooltip: 'Search for "$query"',
      ),
      onTap: () => _performSearch(query),
    );
  }

  Widget _buildSearchTip(
      BuildContext context, String title, String description) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<Note> notes) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Apply sorting before displaying results
    final sortedNotes = _sortNotes(notes);

    return Column(
      children: [
        // Results header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Text(
                '${notes.length} result${notes.length == 1 ? '' : 's'} for "$_currentQuery"',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.sort,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => _showSortOptions(context),
                tooltip: 'Sort results',
                // Ensure minimum touch target
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.minTouchTarget,
                  minHeight: AppSpacing.minTouchTarget,
                ),
              ),
            ],
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: sortedNotes.length,
            itemBuilder: (context, index) {
              return _buildSearchResultCard(context, sortedNotes[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultCard(BuildContext context, Note note) {
    // Use the shared NoteCard widget for consistent design
    return NoteCard(
      note: note,
      onTap: () => context.push(AppRoutes.noteDetail(note.id)),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    // Use the shared EmptyState widget for consistent design
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'No notes match "$_currentQuery". Try different keywords or check your spelling.',
    );
  }

  void _showSearchFilters(BuildContext context) {
    // Use shared ActionSheet widget for consistent design
    ActionSheet.show(
      context: context,
      title: 'Search Filters',
      items: [
        ActionSheetItem(
          icon: Icons.push_pin,
          title: 'Pinned Notes Only',
          onTap: () => _performSearch('pinned'),
        ),
        ActionSheetItem(
          icon: Icons.favorite,
          title: 'Favorite Notes Only',
          onTap: () => _performSearch('favorites'),
        ),
        ActionSheetItem(
          icon: Icons.archive,
          title: 'Archived Notes Only',
          onTap: () => _performSearch('archived'),
        ),
        ActionSheetItem(
          icon: Icons.today,
          title: 'Notes from Today',
          onTap: () => _performSearch('today'),
        ),
      ],
    );
  }

  void _showSortOptions(BuildContext context) {
    // Use shared ActionSheet widget for consistent design
    ActionSheet.show(
      context: context,
      title: 'Sort Results',
      items: [
        ActionSheetItem(
          icon: Icons.access_time,
          title: 'Most Recent',
          onTap: () {
            setState(() {
              _currentSortOption = SearchSortOption.mostRecent;
            });
          },
          trailing: _currentSortOption == SearchSortOption.mostRecent
              ? Icon(
                  Icons.check,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        ActionSheetItem(
          icon: Icons.title,
          title: 'Alphabetical',
          onTap: () {
            setState(() {
              _currentSortOption = SearchSortOption.alphabetical;
            });
          },
          trailing: _currentSortOption == SearchSortOption.alphabetical
              ? Icon(
                  Icons.check,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
        ActionSheetItem(
          icon: Icons.search,
          title: 'Best Match',
          onTap: () {
            setState(() {
              _currentSortOption = SearchSortOption.bestMatch;
            });
          },
          trailing: _currentSortOption == SearchSortOption.bestMatch
              ? Icon(
                  Icons.check,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
        ),
      ],
    );
  }

} 