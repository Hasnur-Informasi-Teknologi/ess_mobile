class DokumenModel {
  final int id;
  final int tipeDokumen;
  final String fileType;
  final String fileName;
  final String createdAt;
  final String createdBy;
  final String lampiran;

  DokumenModel({
    required this.id,
    required this.tipeDokumen,
    required this.fileType,
    required this.fileName,
    required this.createdAt,
    required this.createdBy,
    required this.lampiran,
  });

  factory DokumenModel.fromJson(Map<String, dynamic> json) {
    return DokumenModel(
      id: json['id'],
      tipeDokumen: json['tipe_dokumen'],
      fileType: json['file_type'],
      fileName: json['file_name'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      lampiran: json['lampiran'],
    );
  }
}
