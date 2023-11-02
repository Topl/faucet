class DartCallback {
  /// Callback's name
  ///
  /// Note: Must be UNIQUE
  final String name;

  /// Callback function
  final Function(dynamic message) callBack;

  /// Constructor
  const DartCallback({
    required this.name,
    required this.callBack,
  });

  @override
  bool operator ==(Object other) => other is DartCallback && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
