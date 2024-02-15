// class Data {
//   String? nrp;
//   String? name;
//   String? email;
//   String? role;
//   String? entitas;
//   String? pangkat;
//   String? status;

//   Data({
//     required this.nrp,
//     required this.name,
//     required this.email,
//     required this.role,
//     required this.entitas,
//     required this.pangkat,
//     required this.status,
//   });
// }

// List<Data> myData = [
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "MADE WARSANA",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "Adam Freelance",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "Adam",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
//   Data(
//     nrp: "16120034",
//     name: "Adam",
//     email: "adam@gmail.com",
//     role: "employe",
//     entitas: "Hasnur Resources Terminal",
//     pangkat: "Supervisor",
//     status: "Tidak Aktif",
//   ),
// ];

class UserManagementModel {
  String nrp;
  String name;
  String email;
  String role;
  String entitas;
  String pangkat;
  String status;

  UserManagementModel({
    required this.nrp,
    required this.name,
    required this.email,
    required this.role,
    required this.entitas,
    required this.pangkat,
    required this.status,
  });

  factory UserManagementModel.fromJson(Map<String, dynamic> json) {
    return UserManagementModel(
      nrp: json["nrp"],
      name: json["nama"],
      email: json["email"],
      role: json["role"],
      entitas: json["entitas"],
      pangkat: json["pangkat"],
      status: json["status"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "nrp": nrp,
      "nama": name,
      "email": email,
      "role": role,
      "entitas": entitas,
      "pangkat": pangkat,
      "status": status,
    };
  }
}
