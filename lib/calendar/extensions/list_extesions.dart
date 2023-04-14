extension ExtendedList on List {
  E indexOrNull<E>(int index) =>  index +1 <= length ? this[index] : null;
  E firstOrNull<E>() => isEmpty ? null : first;
  E lastOrNull<E>() => isEmpty ? null : last;
}