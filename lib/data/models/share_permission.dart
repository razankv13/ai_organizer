

/// Permission levels for shared notes
enum SharePermission {
  /// Can only view the note
  view,

  /// Can view and edit the note
  edit;

  /// Display name for the permission
  String get displayName {
    switch (this) {
      case SharePermission.view:
        return 'View only';
      case SharePermission.edit:
        return 'Can edit';
    }
  }

  /// Description of what the permission allows
  String get description {
    switch (this) {
      case SharePermission.view:
        return 'Can view note content but cannot make changes';
      case SharePermission.edit:
        return 'Can view and make changes to the note';
    }
  }

  /// Parse permission from string
  static SharePermission fromString(String value) {
    return SharePermission.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SharePermission.view,
    );
  }
}
