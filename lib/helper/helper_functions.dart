bool isWhite(int index) {
  final int row = ((index / 8).floor());
  final int col = (((index % 8)).ceil()) - 1;

  bool isWhite = (row + col) % 2 == 0;

  return isWhite;
}
