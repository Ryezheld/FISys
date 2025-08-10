class Stuffing {
  final String status;
  final String msg;
  final dynamic data;

  Stuffing({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory Stuffing.fromJson(Map<String, dynamic> json) {
    return Stuffing(
      status: json['status'],
      msg: json['msg'],
      data: json['data'],
    );
  }
}

class Unit {
  final String noSl;
  final String tipe;
  final String noRangka;
  final String noMesin;
  final String warna;
  final String deskripsi;

  Unit({
    required this.noSl,
    required this.tipe,
    required this.noRangka,
    required this.noMesin,
    required this.warna,
    required this.deskripsi,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      noSl: json['no_sl'],
      tipe: json['tipe'],
      noRangka: json['no_rangka'],
      noMesin: json['no_mesin'],
      warna: json['warna'],
      deskripsi: json['deskripsi'],
    );
  }
}

class ListStuffing {
  late String noStl;
  late String tglStuffing;
  late String kapal;
  late String noCont;
  late String totalUnit;
  late String noVoyage;
  late String noCont2;
  late String idCrossdock;

  ListStuffing({
    required this.noStl,
    required this.tglStuffing,
    required this.kapal,
    required this.noCont,
    required this.totalUnit,
    required this.noVoyage,
    required this.noCont2,
    required this.idCrossdock,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'no_stl': noStl,
      'tgl_stuffing': tglStuffing,
      'kapal': kapal,
      'no_cont': noCont,
      'total_unit': totalUnit,
      'no_voyage': noVoyage,
      'no_cont2': noCont2,
      'id_crossdock': idCrossdock,
    };
    return map;
  }

  ListStuffing.fromMap(Map<dynamic, dynamic> map) {
    noStl = map['no_stl'];
    tglStuffing = map['tgl_stuffing'];
    kapal = map['kapal'];
    noCont = map['no_cont'];
    totalUnit = map['total_unit'];
    noVoyage = map['no_voyage'];
    noCont2 = map['no_cont2'];
    idCrossdock = map['id_crossdock'];
  }

  factory ListStuffing.fromJson(Map<String, dynamic> parsedJson) {
    return ListStuffing(
      noStl: parsedJson['no_stl'],
      tglStuffing: parsedJson['tgl_stuffing'],
      kapal: parsedJson['kapal'],
      noCont: parsedJson['no_cont'],
      totalUnit: parsedJson['total_unit'],
      noVoyage: parsedJson['no_voyage'],
      noCont2: parsedJson['no_cont2'],
      idCrossdock: parsedJson['id_crossdock'],
    );
  }
}

class DetailStuffing {
  late String noStl;
  late String tglStuffing;
  late String xpdc;
  late String kapal;
  late String noCont;
  late String noCont2;
  late String noVoyage;
  late String eta;
  late String etd;
  late String statusCrossDock;
  late List<Unit> listUnit;

  DetailStuffing({
    required this.noStl,
    required this.tglStuffing,
    required this.xpdc,
    required this.kapal,
    required this.noCont,
    required this.noCont2,
    required this.noVoyage,
    required this.eta,
    required this.etd,
    required this.statusCrossDock,
    required this.listUnit,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'no_stl': noStl,
      'tgl_stuffing': tglStuffing,
      'xpdc': xpdc,
      'kapal': kapal,
      'no_cont': noCont,
      'no_cont2': noCont2,
      'no_voyage': noVoyage,
      'eta': eta,
      'etd': etd,
      'status_crossdock': statusCrossDock,
    };
    return map;
  }

  DetailStuffing.fromMap(Map<dynamic, dynamic> map) {
    noStl = map['no_stl'];
    tglStuffing = map['tgl_stuffing'];
    xpdc = map['xpdc'];
    kapal = map['kapal'];
    noCont = map['no_cont'];
    noCont2 = map['no_cont2'];
    noVoyage = map['no_voyage'];
    eta = map['eta'];
    etd = map['etd'];
    statusCrossDock = map['status_crossdock'];
  }

  factory DetailStuffing.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['list_unit'] as List;
    List<Unit> detailUnitList = list.map((i) => Unit.fromJson(i)).toList();

    return DetailStuffing(
      noStl: parsedJson['no_stl'],
      tglStuffing: parsedJson['tgl_stuffing'],
      xpdc: parsedJson['xpdc'],
      kapal: parsedJson['kapal'],
      noCont: parsedJson['no_cont'],
      noCont2: parsedJson['no_cont2'],
      noVoyage: parsedJson['no_voyage'],
      eta: parsedJson['eta'],
      etd: parsedJson['etd'],
      statusCrossDock: parsedJson['status_crossdock'],
      listUnit: detailUnitList,
    );
  }
}