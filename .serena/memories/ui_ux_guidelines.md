# UI/UX Guidelines: AI-Powered Organizer App

## Design Philosophy

### Core Principles
1. **Clarity First**: Clean, uncluttered interface that prioritizes content readability
2. **Minimal Design Language**: Subtle visual elements that don't distract from content
3. **Effortless Interaction**: Intuitive gestures and familiar patterns
4. **Content-Centric**: Design serves the content, not the other way around
5. **Thoughtful Hierarchy**: Clear visual structure guides user attention
6. **Consistent Familiarity**: Build on established mobile note-taking patterns
7. **Refined Simplicity**: Attention to detail without visual complexity

### Visual Identity
- **Minimalist Aesthetic**: Clean interface with generous whitespace
- **Purposeful Typography**: Clear hierarchy using Inter font family
- **Restrained Color**: Neutral palette with purposeful accent usage
- **Subtle Depth**: Light shadows and layering for card separation
- **Smooth Motion**: Gentle, natural transitions and animations

---

## Design System

### Color Palette

#### Primary Colors
```dart
// Light Theme - Default
// Backgrounds
backgroundColor: Color(0xFFF5F5F5),        // Light gray background
cardBackground: Color(0xFFFFFFFF),        // White cards
surfaceBackground: Color(0xFFFAFAFA),     // Slightly off-white surface

// Text Colors
primaryText: Color(0xFF1A1A1A),           // Near-black for titles
secondaryText: Color(0xFF6B6B6B),         // Medium gray for body text
tertiaryText: Color(0xFF8E8E8E),          // Light gray for metadata
placeholderText: Color(0xFFB0B0B0),       // Very light gray for hints

// Borders & Dividers
borderColor: Color(0xFFE8E8E8),           // Very subtle borders
dividerColor: Color(0xFFF0F0F0),          // Minimal dividers

// Accent Colors
accentPrimary: Color(0xFF007AFF),         // iOS-style blue for links/actions
accentSecondary: Color(0xFF5856D6),       // Purple for special features
destructive: Color(0xFFFF5454),           // Red for delete actions
success: Color(0xFF34C759),               // Green for success states
warning: Color(0xFFFFCC00),               // Yellow for warnings

// Action Sheet / Modal
modalBackground: Color(0xFF3A3A3A),       // Dark gray for action sheets
modalText: Color(0xFFFFFFFF),             // White text on dark modals
modalTextSecondary: Color(0xFFE0E0E0),    // Light gray for modal secondary text

// Interactive States
pressedOverlay: Color(0x10000000),        // 6% black overlay for pressed state
focusedBorder: Color(0xFF007AFF),         // Blue border for focused inputs
selectedBackground: Color(0xFFF0F0F0),    // Light gray for selected items
```

#### Dark Theme (Optional)
```dart
// Dark Theme - For future implementation
backgroundColor: Color(0xFF1A1A1A),        // Near-black background
cardBackground: Color(0xFF2D2D2D),        // Dark gray cards
surfaceBackground: Color(0xFF252525),     // Slightly lighter surface

primaryText: Color(0xFFFFFFFF),           // White text
secondaryText: Color(0xFFB0B0B0),         // Light gray text
tertiaryText: Color(0xFF8E8E8E),          // Medium gray for metadata

borderColor: Color(0xFF3A3A3A),           // Subtle dark borders
dividerColor: Color(0xFF303030),          // Dark dividers
```

### Typography System

#### Font Family
```dart
// Primary Font: Inter (Google Fonts)
// Fallback: SF Pro / Roboto (System fonts)
import 'package:google_fonts/google_fonts.dart';

// Base font configuration
static TextTheme textTheme = GoogleFonts.interTextTheme();
```

#### Text Styles
```dart
// Large Titles (Screen headers)
displayLarge: GoogleFonts.inter(
  fontSize: 34,
  fontWeight: FontWeight.w700,           // Bold
  letterSpacing: 0.4,
  height: 1.2,
  color: Color(0xFF1A1A1A),
),

// Section Headers
displayMedium: GoogleFonts.inter(
  fontSize: 28,
  fontWeight: FontWeight.w600,           // Semi-bold
  letterSpacing: 0.35,
  height: 1.3,
  color: Color(0xFF1A1A1A),
),

// Small Headers
displaySmall: GoogleFonts.inter(
  fontSize: 22,
  fontWeight: FontWeight.w600,           // Semi-bold
  letterSpacing: 0.35,
  height: 1.3,
  color: Color(0xFF1A1A1A),
),

// Note Titles / Card Titles
titleLarge: GoogleFonts.inter(
  fontSize: 18,
  fontWeight: FontWeight.w600,           // Semi-bold
  letterSpacing: 0.15,
  height: 1.4,
  color: Color(0xFF1A1A1A),
),

// Subtitles / Section Labels
titleMedium: GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w600,           // Semi-bold
  letterSpacing: 0.15,
  height: 1.4,
  color: Color(0xFF1A1A1A),
),

// Small Titles
titleSmall: GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w600,           // Semi-bold
  letterSpacing: 0.1,
  height: 1.4,
  color: Color(0xFF1A1A1A),
),

// Body Text (Note content)
bodyLarge: GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w400,           // Regular
  letterSpacing: 0.15,
  height: 1.5,
  color: Color(0xFF2D2D2D),
),

// Standard Body Text
bodyMedium: GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,           // Regular
  letterSpacing: 0.25,
  height: 1.5,
  color: Color(0xFF6B6B6B),
),

// Small Body Text / Descriptions
bodySmall: GoogleFonts.inter(
  fontSize: 12,
  fontWeight: FontWeight.w400,           // Regular
  letterSpacing: 0.4,
  height: 1.5,
  color: Color(0xFF8E8E8E),
),

// Button Text
labelLarge: GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w600,           // Semi-bold
  letterSpacing: 0.5,
  height: 1.2,
  color: Color(0xFFFFFFFF),
),

// Tab Labels / Small Buttons
labelMedium: GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w500,           // Medium
  letterSpacing: 0.5,
  height: 1.2,
  color: Color(0xFF1A1A1A),
),

// Captions / Metadata
labelSmall: GoogleFonts.inter(
  fontSize: 11,
  fontWeight: FontWeight.w400,           // Regular
  letterSpacing: 0.5,
  height: 1.3,
  color: Color(0xFF8E8E8E),
),
```

### Spacing & Layout System

#### Spacing Scale
```dart
class AppSpacing {
  // Micro spacing
  static const double xxxs = 2.0;
  static const double xxs = 4.0;
  static const double xs = 8.0;

  // Standard spacing
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;

  // Border radius values (consistent rounded corners)
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;

  // Card shadows
  static const double shadowBlur = 8.0;
  static const double shadowSpread = 0.0;
  static const Offset shadowOffset = Offset(0, 2);

  // Safe area padding (respects device notches)
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
      bottom: MediaQuery.of(context).padding.bottom,
    );
  }

  // Responsive spacing
  static double responsive(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 1200) return tablet ?? mobile * 1.25;
    return desktop ?? mobile * 1.5;
  }
}
```

#### Layout Constants
```dart
class AppLayout {
  // Screen padding
  static const double screenPaddingHorizontal = 16.0;
  static const double screenPaddingVertical = 16.0;

  // Card spacing
  static const double cardSpacing = 12.0;
  static const double cardPadding = 16.0;

  // List item spacing
  static const double listItemSpacing = 8.0;
  static const double listItemPadding = 16.0;

  // Maximum content width (for large screens)
  static const double maxContentWidth = 800.0;

  // Minimum touch target (accessibility)
  static const double minTouchTarget = 44.0;
}
```

### Shadows & Elevation

```dart
class AppShadows {
  // Subtle card shadow (primary)
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Color(0x0A000000),          // 4% black
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  // Elevated card shadow (on press/focus)
  static List<BoxShadow> get cardElevatedShadow => [
    BoxShadow(
      color: Color(0x14000000),          // 8% black
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // Action sheet / modal shadow
  static List<BoxShadow> get modalShadow => [
    BoxShadow(
      color: Color(0x33000000),          // 20% black
      blurRadius: 24,
      offset: Offset(0, -4),
      spreadRadius: 0,
    ),
  ];

  // No shadow (flat)
  static List<BoxShadow> get none => [];
}
```

---

## Core UI Components

### 1. Note Card Component

```dart
/// Primary note card used in list views
class NoteCard extends StatelessWidget {
  final String title;
  final String? date;
  final String? preview;
  final List<String>? tags;
  final bool hasAttachment;
  final bool isLocked;
  final bool hasAudio;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppLayout.screenPaddingHorizontal,
        vertical: AppLayout.listItemSpacing / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          splashColor: Color(0x10000000),
          highlightColor: Color(0x08000000),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row (title + date)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: context.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (date != null) ...[
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        date!,
                        style: context.bodySmall.copyWith(
                          color: Color(0xFF8E8E8E),
                        ),
                      ),
                    ],
                  ],
                ),

                // Preview content
                if (preview != null) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    preview!,
                    style: context.bodyMedium.copyWith(
                      color: Color(0xFF6B6B6B),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Audio waveform (if applicable)
                if (hasAudio) ...[
                  SizedBox(height: AppSpacing.md),
                  _buildAudioWaveform(),
                ],

                // Tags (if applicable)
                if (tags != null && tags!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: tags!.map((tag) => _buildTag(tag)).toList(),
                  ),
                ],

                // Bottom icons row
                if (hasAttachment || isLocked) ...[
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      if (isLocked)
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: Color(0xFF8E8E8E),
                        ),
                      if (hasAttachment && isLocked)
                        SizedBox(width: AppSpacing.xs),
                      if (hasAttachment)
                        Icon(
                          Icons.attach_file,
                          size: 16,
                          color: Color(0xFF8E8E8E),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        '#$tag',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B6B6B),
        ),
      ),
    );
  }

  Widget _buildAudioWaveform() {
    return Row(
      children: [
        // Play button
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow,
            size: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        // Waveform visualization
        Expanded(
          child: Container(
            height: 32,
            child: CustomPaint(
              painter: WaveformPainter(),
            ),
          ),
        ),
      ],
    );
  }
}
```

### 2. Search Bar Component

```dart
/// Search bar used at the top of list screens
class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;

  const AppSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search your notes...',
    this.onChanged,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppLayout.screenPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: Color(0xFFE8E8E8),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB0B0B0),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF8E8E8E),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}
```

### 3. Tab Bar Component

```dart
/// Simple tab bar with underline indicator
class SimpleTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const SimpleTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppLayout.screenPaddingHorizontal,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? Color(0xFF1A1A1A)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Color(0xFF1A1A1A)
                      : Color(0xFF8E8E8E),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
```

### 4. Action Sheet / Bottom Menu

```dart
/// Dark modal action sheet for contextual actions
class ActionSheet extends StatelessWidget {
  final List<ActionSheetItem> items;

  const ActionSheet({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3A3A3A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd),
        ),
        boxShadow: AppShadows.modalShadow,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 36,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Color(0xFF6B6B6B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Action items
            ...items.map((item) => _buildActionItem(context, item)).toList(),

            SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, ActionSheetItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          item.onTap();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 22,
                color: item.isDestructive
                    ? Color(0xFFFF5454)
                    : Color(0xFFFFFFFF),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                item.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: item.isDestructive
                      ? Color(0xFFFF5454)
                      : Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionSheetItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const ActionSheetItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}
```

### 5. Checkbox List Item

```dart
/// Checkbox item for to-do lists within notes
class CheckboxListItem extends StatelessWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CheckboxListItem({
    Key? key,
    required this.text,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: Color(0xFF007AFF),
            checkColor: Colors.white,
            side: BorderSide(
              color: Color(0xFFB0B0B0),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isChecked
                  ? Color(0xFF8E8E8E)
                  : Color(0xFF2D2D2D),
              decoration: isChecked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
```

### 6. Input Field Component

```dart
/// Standard input field for forms
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const AppTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF1A1A1A),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8E8E8E),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB0B0B0),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Color(0xFF8E8E8E), size: 22)
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: Color(0xFF007AFF),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: Color(0xFFFF5454),
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Color(0xFFFAFAFA),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
```

### 7. Primary Button

```dart
/// Primary action button (iOS-style)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF007AFF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Color(0xFFB0B0B0),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
```

### 8. Secondary Button (Text Button)

```dart
/// Secondary/text button for less prominent actions
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? Color(0xFF007AFF),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
```

---

## Screen Layouts

### 1. Notes List Screen Layout
```
┌─────────────────────────────────────┐
│  Notes                          ⋮   │  ← App bar (white background)
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🔍  Search your notes...      │  │  ← Search bar (light gray)
│  └───────────────────────────────┘  │
│                                     │
│  All          Folders               │  ← Tab bar with underline
│  ══                                 │    indicator
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Summary-2021.10.22   Oct 22   │  │  ← Note card (white)
│  │                               │  │
│  │ Research methods :            │  │
│  │ • A/B Testing                 │  │
│  │ A/B testing is an experiment  │  │
│  │ where a researcher test...    │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Voice Note-2021.10.04 Oct 04  │  │  ← Voice note card
│  │                               │  │
│  │ ▶ ▁▃▂▅▇▃▆▂▅▃▆▂▅▃▆▂▅▃▆▂       │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ To-Do List           Sep 23   │  │  ← To-do note card
│  │                               │  │
│  │ ☑ Morning Workout 10-min      │  │
│  │ ☑ Read a book about Design... │  │
│  │ ☐ Study for mid term exam     │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ Diary-2021.07.17     Jul 17   │  │  ← Locked note
│  │                               │  │
│  │ 🔒  Password                  │  │
│  │     ___________________       │  │
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### 2. Note Detail Screen Layout
```
┌─────────────────────────────────────┐
│  ← Notes                    ✎  ⋮   │  ← App bar with back + actions
├─────────────────────────────────────┤
│                                     │
│  Summary-2021.10.22                 │  ← Title (bold)
│  October 22, 14:05                  │  ← Timestamp
│                                     │
│  Research methods :                 │  ← Content
│  • A/B Testing                      │
│  A/B testing is an experiment where │
│  a researcher test two variants of  │
│  the project, A and B, to see which │
│  one performs or converts better.   │
│  It's widely used as a marketing... │
│                                     │
│  • Concept testing                  │
│  Concept testing is the process of  │
│  using surveys to evaluate consumer │
│  acceptance of a new product idea   │
│  before it is introduced to the...  │
│                                     │
│  • Customer feedback                │
│  Customer feedback is a research... │
│                                     │
└─────────────────────────────────────┘
```

### 3. Action Sheet (Modal Menu)
```
                      │
                      │  Note Detail Screen
                      │
┌─────────────────────┴─────────────────┐
│  ─────────                            │  ← Handle
│                                       │
│  ══  Save as PDF                      │  ← Action items
│                                       │
│  📁  Add to Folder                    │
│                                       │
│  🔒  Lock this note                   │
│                                       │
│  📤  Send to                          │
│                                       │
│  🗑️  Delete this note                │  ← Destructive (red)
│                                       │
└───────────────────────────────────────┘
  Dark background (#3A3A3A)
  White text / Red for delete
```

---

## Animation & Interaction Guidelines

### Animation Principles
1. **Subtle & Quick**: Animations should be fast (150-300ms) and barely noticeable
2. **Natural Physics**: Use appropriate easing curves (easeInOut, easeOut)
3. **Purposeful**: Animate only to provide feedback or guide attention
4. **Performance**: Avoid expensive animations on lists and scrolling

### Standard Animations
```dart
class AppAnimations {
  // Standard durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);

  // Standard curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve deemphasized = Curves.easeInCubic;

  // Scale animation for buttons
  static Animation<double> scaleAnimation(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: controller, curve: defaultCurve),
    );
  }

  // Fade animation for overlays
  static Animation<double> fadeAnimation(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: defaultCurve),
    );
  }

  // Slide animation for sheets
  static Animation<Offset> slideAnimation(AnimationController controller) {
    return Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: emphasized),
    );
  }
}
```

### Interaction States

```dart
// Button press effect
GestureDetector(
  onTapDown: (_) => setState(() => _isPressed = true),
  onTapUp: (_) => setState(() => _isPressed = false),
  onTapCancel: () => setState(() => _isPressed = false),
  child: AnimatedScale(
    scale: _isPressed ? 0.95 : 1.0,
    duration: AppAnimations.fast,
    child: yourWidget,
  ),
)

// Card elevation on press
AnimatedContainer(
  duration: AppAnimations.fast,
  decoration: BoxDecoration(
    boxShadow: _isPressed
        ? AppShadows.cardElevatedShadow
        : AppShadows.cardShadow,
  ),
)
```

---

## Accessibility Guidelines

### Text Contrast
- Ensure minimum WCAG AA contrast ratios:
  - Normal text (< 18pt): 4.5:1
  - Large text (≥ 18pt): 3:1
- Primary text on white: #1A1A1A (16.9:1) ✓
- Secondary text on white: #6B6B6B (5.7:1) ✓

### Touch Targets
- Minimum touch target: 44x44 dp (iOS standard)
- Provide adequate spacing between interactive elements
- Use padding to increase touch area without increasing visual size

### Screen Reader Support
```dart
// Semantic labels for icons
Semantics(
  label: 'Search notes',
  child: Icon(Icons.search),
)

// Exclude decorative elements
Semantics(
  excludeSemantics: true,
  child: DecorativeWidget(),
)

// Mark headers
Semantics(
  header: true,
  child: Text('Notes'),
)
```

### Dynamic Type Support
- Use relative font sizes that scale with system settings
- Test with largest accessibility text sizes
- Ensure layouts don't break with large text

---

## Special Use Cases

### AI-Generated Content Indicators

```dart
/// Tag indicating AI-suggested content
class AITag extends StatelessWidget {
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFE8F5FF),          // Light blue background
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(
          color: Color(0xFF007AFF).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 12,
            color: Color(0xFF007AFF),
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF007AFF),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Empty States

```dart
/// Empty state for list screens
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Color(0xFFE8E8E8),
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8E8E8E),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Loading States

```dart
/// Shimmer loading placeholder for note cards
class NoteCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppLayout.screenPaddingHorizontal,
        vertical: AppLayout.listItemSpacing / 2,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          // Content skeleton
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Implementation Checklist

When implementing any new screen or component, ensure:

- [ ] Uses correct background color (#F5F5F5 for screens)
- [ ] Uses white (#FFFFFF) for cards with subtle shadow
- [ ] Uses Inter font family from Google Fonts
- [ ] Follows correct text hierarchy and colors
- [ ] Uses consistent spacing from AppSpacing
- [ ] Uses consistent border radius (12dp for most cards)
- [ ] Implements proper touch targets (minimum 44x44)
- [ ] Includes appropriate semantic labels
- [ ] Animates interactions subtly (150-300ms)
- [ ] Handles loading and empty states
- [ ] Ensures WCAG AA contrast compliance
- [ ] Tests with dynamic type/large text sizes
- [ ] Matches the design reference screenshot

---

## Design Reference

This UI/UX guideline is based on the design screenshot located at:
`/Users/razaabbas/Desktop/Development/projects/ai_organizer/design_screenshot/original-85d80a81d0d83bbb45a4fb659b6cc33b.webp`

The design follows a **minimalist, light theme** approach with:
- Clean white cards on light gray background
- Subtle shadows for depth
- Inter font family
- Minimal color usage
- iOS-inspired interaction patterns
- Focus on content readability and clarity

All implementations should refer back to this design for consistency.
