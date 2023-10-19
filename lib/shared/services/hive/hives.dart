enum HivesBox {
  customChains(
    id: 'customChains',
  ),
  rateLimit(
    id: 'rateLimit',
  );

  const HivesBox({required this.id});

  final String id;
}
