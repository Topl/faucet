enum Status {
  pending('pending'),
  confirmed('confirmed'),
  failed('failed');

  const Status(this.value);
  final String value;
}
