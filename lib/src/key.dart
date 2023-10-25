class KeySelector {
  String key;
  int orEqual;
  int offset;

  KeySelector(this.key, this.orEqual, this.offset);

  factory KeySelector.firstGreaterOrEqual(String key) => key.firstGreaterOrEqual;
  factory KeySelector.firstGreaterThan(String key) => key.firstGreaterThan;
  factory KeySelector.lastLessOrEqual(String key) => key.lastLessOrEqual;
  factory KeySelector.lastLessThan(String key) => key.lastLessThan;

  operator +(int val) => KeySelector(key, orEqual, offset + val);
  operator -(int val) => KeySelector(key, orEqual, offset - val);
}

extension AsKeyValue on String {
  KeySelector get firstGreaterOrEqual => KeySelector(this, 0, 1);
  KeySelector get firstGreaterThan => KeySelector(this, 1, 1);
  KeySelector get lastLessOrEqual => KeySelector(this, 1, 0);
  KeySelector get lastLessThan => KeySelector(this, 0, 0);
}

extension SystemKey on int {
  bool get isNotSystemKey => this != 0xFF;
  bool get isSystemKey => this == 0xFF;
}
