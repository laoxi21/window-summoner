getOrderedKeys(args*) {
  keys := []
  isKey := true
  for k in args {
    if (isKey) {
      keys.Push(k)
      isKey := false
    } else {
      isKey := true
    }
  }
  return keys
}

class OrderedMap extends Map {
  __New(args*) {
    this._keys := getOrderedKeys(args*)
    return super.__New(args*)
  }
  Keys(newValue := unset) {
    if IsSet(newValue) {
      this._keys := newValue
    }
    return this._keys
  }
}