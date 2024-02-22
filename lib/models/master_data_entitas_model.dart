class Dataku {
  String? kode;
  String? nama;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;
  String? deletedAt;
  String? deletedBy;

  Dataku({
    this.kode,
    this.nama,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
  });

  factory Dataku.fromJson(Map<String, dynamic> json) => Dataku(
        kode: json["kode"],
        nama: json["nama"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        deletedAt: json["deleted_at"],
        deletedBy: json["deleted_by"],
      );

  Map<String, dynamic> toJson() => {
        "kode": kode,
        "nama": nama,
        "created_at": createdAt,
        "created_by": createdBy,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "deleted_at": deletedAt,
        "deleted_by": deletedBy,
      };
}

class TotalPage {
  int? totalRecords;

  TotalPage({
    this.totalRecords,
  });

  factory TotalPage.fromJson(Map<String, dynamic> json) => TotalPage(
        totalRecords: json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords,
      };
}

class MyModel {
  List<Dataku>? dataku;
  TotalPage? totalPage;

  MyModel({
    this.dataku,
    this.totalPage,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) => MyModel(
        dataku:
            List<Dataku>.from(json["dataku"].map((x) => Dataku.fromJson(x))),
        totalPage: TotalPage.fromJson(json["totalPage"]),
      );

  Map<String, dynamic> toJson() => {
        "dataku": List<dynamic>.from(dataku!.map((x) => x.toJson())),
        "totalPage": totalPage!.toJson(),
      };
}
