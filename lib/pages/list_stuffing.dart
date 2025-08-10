import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:FISys/providers/user_provider.dart';
import 'package:FISys/network/model/unit.dart';
import 'package:FISys/network/model/list_stuffing.dart';
import 'package:FISys/network/model/detail_stuffing.dart';
import 'package:FISys/network/api/api_provider.dart';
import 'package:FISys/functions.dart';

class ListStuffingPage extends StatefulWidget {
  const ListStuffingPage({Key? key}) : super(key: key);
  @override
  ListStuffingPageState createState() => ListStuffingPageState();
}

class ListStuffingPageState extends State<ListStuffingPage> {
  String apiUrl = '';
  bool _isLoading = false; // Boolean to keep track of the `syncData`
  List<ListStuffingData> stuffingList = [];
  late DetailStuffing detailStuffing;
  List<UnitData> unitList = [];

  @override
  void initState() {
    super.initState();
    Functions().checkLoginStatus(context).then((url) {
      // Check for login status
      apiUrl = url;
    });
  }

  Future<void> syncData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.users[0].user;
      ApiProvider().setUrl(apiUrl);
      final syncRes = await ApiProvider()
          .fetchListStuffing(formattedDate1, formattedDate2, user.toString());
      stuffingList = syncRes.data;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
    }
    setState(() {});
  }

  Future<List<UnitData>> detailData(noStl) async {
    try {
      ApiProvider().setUrl(apiUrl);
      final detRes = await ApiProvider().fetchDetailStuffing(noStl);
      detailStuffing = detRes.data;
      unitList = detailStuffing.listUnit;
      return unitList;
    } catch (e) {
      return [];
    }
  }

  Widget _buildRichText(String label, String value, bool isLabel) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label\n',
            style: TextStyle(
              fontSize: isLabel ? 12 : 20, // Adjust the font size as needed
              fontWeight: isLabel ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: isLabel ? 16 : 12, // Adjust the font size as needed
              fontWeight: isLabel ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const TextSpan(text: '\n', style: TextStyle(fontSize: 1)),
        ],
      ),
    );
  }

  void _showDetail(List<UnitData> unit) {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height *
            0.95, // Set the height of the widget as needed
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Center(
                  child: Text(
                'Detail Data Stuffing',
                style: TextStyle(color: Colors.white),
              )),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                      text: 'Detail',
                      icon: Icon(
                        Icons.library_books,
                        color: Colors.white,
                      )),
                  Tab(
                      text: 'List Unit',
                      icon: Icon(
                        Icons.motorcycle,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRichText('NO STL', detailStuffing.noStl, true),
                        _buildRichText('EKSPEDISI', detailStuffing.xpdc, true),
                        _buildRichText(
                            'NO CONTAINER', detailStuffing.noCont, true),
                        _buildRichText(
                            'NO VOYAGE', detailStuffing.noVoyage, true),
                        _buildRichText('KAPAL', detailStuffing.kapal, true),
                        _buildRichText('ETD', detailStuffing.etd, true),
                        _buildRichText('ETA', detailStuffing.eta, true),
                        _buildRichText(
                            'CROSSDOCK', detailStuffing.statusCrossDock, true),
                        _buildRichText('TOTAL UNIT',
                            detailStuffing.jmlUnit.toString(), true)
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: ListView.builder(
                      itemCount: unitList.length,
                      itemBuilder: (context, index) {
                        final unitData = unitList[index];
                        int itemNumber = index + 1;
                        return Card(
                          child: ListTile(
                            minLeadingWidth: 10,
                            leading: Text(
                              '$itemNumber',
                              style: const TextStyle(fontSize: 16),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(unitData.noMesin),
                                Text(unitData.deskripsi),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${unitData.noRangka}\n${unitData.noSl}'),
                                Text('${unitData.warna}\n'),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? firstDate;
  DateTime? lastDate;
  String formattedDate1 = '';
  String formattedDate2 = '';

  void setDate(DateTime firstDate, DateTime lastDate) {
    // Set the date for data filtering
    formattedDate1 = DateFormat('dd-MM-yyyy').format(firstDate);
    formattedDate2 = DateFormat('dd-MM-yyyy').format(lastDate);
    setState(() {
      syncData();
    });
  }

  void _showDateRangePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih periode tanggal'),
            content: SizedBox(
              width: double.maxFinite, // Set the width as needed
              height: 300, // Set the height as needed
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is PickerDateRange) {
                    final range = args.value as PickerDateRange;
                    firstDate = range.startDate; // Set the first date
                    // Set the last date
                    if (lastDate == null) {
                      // If only a single date is selected
                      lastDate =
                          firstDate; // `lastDate` is the same as `firstDate`
                    } else {
                      lastDate = range.endDate;
                    }
                  }
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  _isLoading = true;
                  if (firstDate != null) {
                    // Do a null check for `firstDate``
                    setDate(firstDate!, lastDate!);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pilih tanggal!')));
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Functions().navigateToDestination(context, '/home');
              },
              color: Colors.white,
            ),
            title: const Text(
              'List Stuffing',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    syncData();
                  },
                  child: ListView.builder(
                      itemCount: stuffingList.length,
                      itemBuilder: (context, index) {
                        final listData = stuffingList[index];
                        return GestureDetector(
                          onTap: () async {
                            final detailStuffingData =
                                await detailData(listData.noStl);
                            _showDetail(detailStuffingData);
                          },
                          child: Card(
                            color: index % 2 == 0
                                ? Colors.white
                                : const Color.fromARGB(160, 242, 242, 242),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('No SL: ${(listData.noStl)}'),
                                      Text('Tanggal: ${(listData.tglStuffing)}')
                                    ],
                                  ),
                                  Text('Nama Kapal: ${(listData.kapal)}'),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'No Container: ${(listData.noCont)}'),
                                      Text('No Voyage: ${(listData.noVoyage)}')
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showDateRangePickerDialog(context);
            },
            child: const Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
          )),
    );
  }
}
