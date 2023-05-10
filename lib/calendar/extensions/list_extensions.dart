extension ExtendedList<E> on List<E?> {
  E? indexOrNull(int index) => index + 1 <= length ? this[index] : null;
  E? firstOrNull() => isEmpty ? null : first;
  E? lastOrNull() => isEmpty ? null : last;
}
