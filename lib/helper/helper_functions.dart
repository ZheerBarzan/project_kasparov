bool isWhite(int index) {
  final int row = index ~/ 8; // integer divison for the row
  final int column = index % 8; // remaider divison for the column

  bool isWhite = (row + column) % 2 == 0;

  return isWhite;
}

bool isInBoard(int row, int column) {
  return row >= 0 && row < 8 && column >= 0 && column < 8;
}
