class Item {
  final int idx;
  final String kode;
  final String nama;
  bool isSelected;

  Item(
      {required this.idx,
      required this.kode,
      required this.nama,
      this.isSelected = false});
}
