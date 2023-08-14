bool isWhite(int index) {
  final int row = ((index / 8).floor());
  final int col = (((index % 8)).ceil());

  bool isWhite = (row + col) % 2 == 0;

  return isWhite;
}

bool isInBoard(int row, int column) {
  return row >= 0 && row < 8 && column >= 0 && column < 8;
}
