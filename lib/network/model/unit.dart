class Unit {
  final String status;
  final String msg;
  final dynamic data;

  Unit({
    required this.status,
    required this.msg,
    this.data,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data')) {
      if (json['data'] is List) {
        final List<UnitData> unitDataList = (json['data'] as List)
            .map((item) => UnitData.fromJson(item))
            .toList();

        return Unit(
          status: json['status'],
          msg: json['msg'],
          data: unitDataList,
        );
      } else if (json['data'] is Map<String, dynamic>) {
        return Unit(
          status: json['status'],
          msg: json['msg'],
          data: UnitData.fromJson(json['data']),
        );
      }
    }
    
   
    return Unit(
      status: json['status'],
      msg: json['msg'],
      data: null,
    );
  }
}


class UnitData {
  final String noSl;
  final String tipe;
  final String noRangka;
  final String noMesin;
  final String warna;
  final String deskripsi;

  UnitData({
    required this.noSl,
    required this.tipe,
    required this.noRangka,
    required this.noMesin,
    required this.warna,
    required this.deskripsi,
  });
  
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'no_sl': noSl,
      'tipe': tipe,
      'no_rangka': noRangka,
      'no_mesin': noMesin,
      'warna': warna,
      'deskripsi': deskripsi
    };
    return map;
  }

  factory UnitData.fromJson(Map<String, dynamic> json) {
    return UnitData(
      noSl: json['no_sl'],
      tipe: json['tipe'],
      noRangka: json['no_rangka'],
      noMesin: json['no_mesin'],
      warna: json['warna'],
      deskripsi: json['deskripsi'],
    );
  }
}