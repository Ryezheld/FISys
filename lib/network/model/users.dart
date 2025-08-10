class Users {
  final String status;
  final String msg;
  final UserData data;

  Users({
    required this.status,
    required this.msg,
    required this.data
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      status: json['status'],
      msg: json['msg'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String idUser;
  final String userLogin;
  final String nama;
  final String user;
  final String idXpdc;
  final String tipeUser;

  UserData({
    required this.idUser,
    required this.userLogin,
    required this.nama,
    required this.user,
    required this.idXpdc,
    required this.tipeUser,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      idUser: json['id_user'],
      userLogin: json['user_login'],
      nama: json['nama'],
      user: json['user'],
      idXpdc: json['id_xpdc'],
      tipeUser: json['tipe_user'],
    );
  }
}