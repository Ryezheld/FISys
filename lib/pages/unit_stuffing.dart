import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FISys/providers/user_provider.dart';
import 'package:FISys/widgets/qr_scanner.dart';
import 'package:FISys/network/model/unit.dart';
import 'package:FISys/network/api/api_provider.dart';
import 'package:FISys/functions.dart';

class UnitStuffingPage extends StatefulWidget {
  const UnitStuffingPage({Key? key}) : super(key: key);
  @override
  UnitStuffingPageState createState() => UnitStuffingPageState();
}

class UnitStuffingPageState extends State<UnitStuffingPage> {
  String apiUrl = '';
  bool _isLoading = true; // Boolean to keep track of `syncData`
  List<UnitData> unitDataList = [];
  late UnitData newUnitData;
  final TextEditingController _mesinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isDataAvailable = false;
  bool qrCodeScanned = false;
  String? matchedData;

  @override
  void initState() {
    super.initState();
    Functions().checkLoginStatus(context).then((url) {
      // Check Login Status
      setState(() {
        apiUrl = url;
        syncData(); // Load the data as the page loads
      });
    });
  }

  Future<void> syncData() async {
    // Load Unit Stuffing data
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.users[0].user;
      ApiProvider().setUrl(apiUrl);
      final syncRes = await ApiProvider().fetchUnit(user.toString());
      unitDataList = syncRes.data;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
    }
    setState(() {});
  }

  Future<bool> checkData(String newData) async {
    // Check if Unit Stuffing data exists or not and return boolean value
    try {
      ApiProvider().setUrl(apiUrl);
      final checkRes = await ApiProvider().checkNoSin(newData);
      if (checkRes.status == '1') {
        if (checkRes.data is UnitData) {
          newUnitData = checkRes.data as UnitData;
        } else {
          showAlertDialog(
              'Received unexpected data type: ${checkRes.data.runtimeType}');
        }
        return true;
      } else {
        showAlertDialog(checkRes.msg);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> submitData(noMesin) async {
    // Submit a new Unit Stuffing data
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.users[0].user;
      ApiProvider().setUrl(apiUrl);
      final submitRes =
          await ApiProvider().submitUnit(user.toString(), noMesin);
      if (submitRes.status == '1') {
        setState(() {
          syncData();
        });
      } else {
        showAlertDialog(
            'Received unexpected data type: ${submitRes.data.runtimeType}');
      }
      showAlertDialog(submitRes.msg);
    } catch (e) {
      final dynamic msg;
      msg = e;
      showAlertDialog(msg);
      throw Exception(e);
    }
  }

  Future<void> hapusData(noMesin) async {
    // Delete an entry of Unit Stuffing data
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.users[0].user;
      ApiProvider().setUrl(apiUrl);
      final hapusRes = await ApiProvider().hapusUnit(user.toString(), noMesin);
      if (hapusRes.status == '1') {
        setState(() {
          syncData();
        });
      } else {
        showAlertDialog(
            'Received unexpected data type: ${hapusRes.data.runtimeType}');
      }
    } catch (e) {
      final dynamic msg;
      msg = e;
      showAlertDialog(msg);
      throw Exception(e);
    }
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Notification'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void setScannedQRCode(String qrCodeResult) {
    // Setting the scan result into the TextField
    setState(() {
      _mesinController.text = qrCodeResult;
    });
  }

  void _focusedOnTextField() {
    // Call this function right after a successful scan
    _focusNode.requestFocus();
  }

  void _formInput() {
    // Open the input form
    isDataAvailable = false;
    String scanResult = '';
    qrCodeScanned = false;

    Widget buildCameraButton() {
      // Camera Button to access the QR Scanner
      return IconButton(
        icon: const Icon(Icons.qr_code_scanner),
        onPressed: () {
          _mesinController.clear();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ScannerWidget(onScanned: (qrCodeData) async {
                    setState(() {
                      scanResult = qrCodeData;
                      qrCodeScanned = true;
                    });

                    if (scanResult.isNotEmpty) {
                      _mesinController.text = scanResult;
                      bool dataAvailable = await checkData(scanResult);
                      if (dataAvailable) {
                        isDataAvailable = true;
                        _focusedOnTextField(); // Focus on the TextField after a successful scan to trigger `CheckData`
                      }
                    }
                  })));
        },
      );
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: TextField(
                        controller: _mesinController,
                        focusNode: _focusNode,
                        decoration:
                            const InputDecoration(hintText: 'Kode Mesin'),
                        onChanged: (noMesin) async {
                          final trimmedNoMesin = noMesin.replaceAll(' ', '');
                          if (trimmedNoMesin.length >= 12) {
                            // Only check for data when input length is 12 or more characters
                            bool result = await checkData(trimmedNoMesin);
                            setState(() {
                              isDataAvailable = result;
                            });
                          } else {
                            setState(() {
                              isDataAvailable = false;
                              matchedData = null;
                            });
                          }
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: buildCameraButton(),
                    ),
                  ],
                ),
                if (isDataAvailable) // If we get a data, show the data
                  // Expected new data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text('No SL: ${newUnitData.noSl}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('No Rangka: ${newUnitData.noRangka}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('No Mesin: ${newUnitData.noMesin}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Tipe: ${newUnitData.tipe}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Warna: ${newUnitData.warna}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Deskripsi: ${newUnitData.deskripsi}'),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          submitData(_mesinController.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      )
                    ],
                  )
                // End of expected new data
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mesinController.dispose();
    super.dispose();
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
            'Unit Stuffing',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await syncData();
                },
                child: ListView.builder(
                    itemCount: unitDataList.length,
                    itemBuilder: (context, index) {
                      final unitData = unitDataList[index];
                      int itemNumber = index + 1;
                      return Card(
                        color: index % 2 == 0
                            ? Colors.white
                            : const Color.fromARGB(160, 242, 242, 242),
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
                          trailing: SizedBox(
                            width: 30,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(unitData.noMesin),
                                    content:
                                        const Text('Yakin mau hapus data ini?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Tidak'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          hapusData(unitData.noMesin);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ya'),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _formInput(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
