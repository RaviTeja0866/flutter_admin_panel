class PermissionGroup {
  final String key;
  final String label;
  final List<String> actions;

  PermissionGroup({
    required this.key,
    required this.label,
    required this.actions,
  });

  factory PermissionGroup.fromFirestore(
      String id, Map<String, dynamic> data) {
    return PermissionGroup(
      key: id,
      label: data['label'],
      actions: List<String>.from(data['actions'] ?? []),
    );
  }
}
