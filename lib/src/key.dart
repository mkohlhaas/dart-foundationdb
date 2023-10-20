// ignore_for_file: unused_element

typedef FdbKey = String;
typedef FdbValue = String;

extension on FdbKey {
  KeySelector get lastLessThan => KeySelector(this, 0, 0);
  KeySelector get lastLessOrEqual => KeySelector(this, 1, 0);
  KeySelector get firstGreaterOrEqual => KeySelector(this, 0, 1);
  KeySelector get firstGreaterThan => KeySelector(this, 1, 1);
}

class KeySelector {
  FdbKey key;
  int orEqual;
  int offset;

  KeySelector(this.key, this.orEqual, this.offset);

  operator +(int val) => KeySelector(key, orEqual, offset + val);
  operator -(int val) => KeySelector(key, orEqual, offset - val);
}
