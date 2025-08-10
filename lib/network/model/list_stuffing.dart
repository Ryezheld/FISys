class ListStuffing {
  final String status;
  final String msg;
  final List<ListStuffingData> data;

  ListStuffing({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory ListStuffing.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    final List<ListStuffingData> listStuffingList = data.map((item) {
      return ListStuffingData.fromJson(item);
    }).toList();

    return ListStuffing(
      status: json['status'],
      msg: json['msg'],
      data: listStuffingList,
    );
  }
}

class ListStuffingData {
  final String noStl;
  final String tglStuffing;
  final String kapal;
  final String noCont;
  final String totalUnit;
  final String noVoyage;
  final String noCont2;
  final String idCrossdock;

  ListStuffingData({
    required this.noStl,
    required this.tglStuffing,
    required this.kapal,
    required this.noCont,
    required this.totalUnit,
    required this.noVoyage,
    required this.noCont2,
    required this.idCrossdock,
  });

  factory ListStuffingData.fromJson(Map<String, dynamic> parsedJson) {
    return ListStuffingData(
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