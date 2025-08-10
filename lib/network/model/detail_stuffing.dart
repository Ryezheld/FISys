import '../model/unit.dart';

class Stuffing {
  final String status;
  final String msg;
  final dynamic data;

  Stuffing({
    required this.status,
    required this.msg,
    this.data,
  });

  factory Stuffing.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('data')) {
      if (json['data'] is List) {
        final List<DetailStuffing> detailStuffingList = (json['data'] as List)
            .map((item) => DetailStuffing.fromJson(item))
            .toList();

        return Stuffing(
          status: json['status'],
          msg: json['msg'],
          data: detailStuffingList,
        );
      } else if (json['data'] is Map<String, dynamic>) {
        return Stuffing(
          status: json['status'],
          msg: json['msg'],
          data: DetailStuffing.fromJson(json['data']),
        );
      }
    }
    
   
    return Stuffing(
      status: json['status'],
      msg: json['msg'],
      data: null,
    );
  }
}

class DetailStuffing {
  final String noStl;
  final String tglStuffing;
  final String xpdc;
  final String kapal;
  final String noCont;
  final String noCont2;
  final String noVoyage;
  final String eta;
  final String etd;
  final String statusCrossDock;
  final int jmlUnit;
  final List<UnitData> listUnit;

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
    required this.jmlUnit,
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
      'jml_unit': jmlUnit,
      'list_unit': listUnit.map((unit) => unit.toMap()).toList(), // Convert listUnit to a list of maps.
    };
    return map;
  }

  factory DetailStuffing.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['list_unit'] as List;
    List<UnitData> unitList = list.map((unitJson) => UnitData.fromJson(unitJson)).toList();

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
      jmlUnit: parsedJson['jml_unit'],
      listUnit: unitList,
    );
  }
}
