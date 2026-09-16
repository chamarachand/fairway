enum PriceSort {
  none,
  lowToHigh,
  highToLow;

  String? get order => switch (this) {
    PriceSort.lowToHigh => 'asc',
    PriceSort.highToLow => 'desc',
    PriceSort.none => null,
  };
}
