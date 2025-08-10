import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

class ScannerWidget extends StatefulWidget {
  final Function(String) onScanned;

  const ScannerWidget({
    super.key,
    required this.onScanned,
  });

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  List<Barcode> barcodes = [];
  Size? _previewBarcode;
  String result = "";
  bool qrCodeScanned = false;
  bool showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  Future<void> _scan() async {
    Size scanPreview = _previewBarcode ?? FlutterMobileVision.PREVIEW;
    try {
      barcodes = await FlutterMobileVision.scan(
        autoFocus: true,
        formats: Barcode.ALL_FORMATS,
        multiple: false,
        scanArea: Size(scanPreview.width + 150, scanPreview.height - 150),
        forceCloseCameraOnTap: true,
        preview: scanPreview,
        camera: FlutterMobileVision.CAMERA_BACK,
      );
      if (!mounted) return;
    } on Exception {
      showDialog(
          context: context,
          builder: ((context) => const AlertDialog(
                title: Text('Notification'),
                content: Text('Scan gagal'),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode Scanner"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Scan Result: $result",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!qrCodeScanned) const Text("You need to scan a QR code"),
                  if (qrCodeScanned && showSaveButton)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          result = "";
                          qrCodeScanned = false;
                          showSaveButton = false;
                        });
                      },
                      child: const Text("Save"),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
