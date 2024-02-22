class DatakuModel {
  List<DatakuItemModel> dataku;
  TotalPageModel totalPage;

  DatakuModel({required this.dataku, required this.totalPage});

  factory DatakuModel.fromJson(Map<String, dynamic> json) {
    var datakuList = json['dataku'] as List;
    List<DatakuItemModel> datakuItems =
        datakuList.map((item) => DatakuItemModel.fromJson(item)).toList();

    return DatakuModel(
      dataku: datakuItems,
      totalPage: TotalPageModel.fromJson(json['totalPage']),
    );
  }
}

class DatakuItemModel {
  String? nrp;
  String? nama;
  String? tglMasuk;
  String? email;
  String? cocd;
  int? roleId;
  String? pangkat;
  String? namaPangkat;
  String? entitas;
  String? role;
  String? terminate;

  DatakuItemModel({
    required this.nrp,
    required this.nama,
    required this.tglMasuk,
    required this.email,
    required this.cocd,
    required this.roleId,
    required this.pangkat,
    required this.namaPangkat,
    required this.entitas,
    required this.role,
    required this.terminate,
  });

  factory DatakuItemModel.fromJson(Map<String, dynamic> json) {
    return DatakuItemModel(
      nrp: json['nrp'],
      nama: json['nama'],
      tglMasuk: json['tgl_masuk'],
      email: json['email'],
      cocd: json['cocd'],
      roleId: json['role_id'],
      pangkat: json['pangkat'],
      namaPangkat: json['nama_pangkat'],
      entitas: json['entitas'],
      role: json['role'],
      terminate: json['terminate'],
    );
  }
}

class TotalPageModel {
  int totalRecords;

  TotalPageModel({required this.totalRecords});

  factory TotalPageModel.fromJson(Map<String, dynamic> json) {
    return TotalPageModel(
      totalRecords: json['total_records'],
    );
  }
}
