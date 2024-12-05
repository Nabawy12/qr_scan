import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String scannedBarcode = ''; // To store the scanned barcode value

  // Function to display the QR code
  Widget _buildQRCode(String data) {
    return PrettyQr(
      data: data,
      size: 200,
      typeNumber: 10, // Controls the size of the QR code
      roundEdges: true, // Makes the corners rounded
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code & Barcode Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display scanned barcode value
            Text(
              'Scanned Barcode: $scannedBarcode',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Scan Button to start the camera
            ElevatedButton(
              onPressed: () => _showScannerDialog(context),
              child: Text('Scan Barcode'),
            ),
            SizedBox(height: 40),
            // QR Code display
            _buildQRCode('https://pub.dev/packages/skeletons/versions.com'),
          ],
        ),
      ),
    );
  }

  // Function to show a dialog to start scanning
  void _showScannerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan Barcode'),
          content: SizedBox(
            height: 300,
            child: MobileScanner(
              onDetect: (BarcodeCapture barcodeCapture) {
                final barcode = barcodeCapture.barcodes.isNotEmpty
                    ? barcodeCapture.barcodes.first
                    : null;
                if (barcode != null && barcode.rawValue != null) {
                  final scannedUrl = barcode.rawValue!;
                  setState(() {
                    scannedBarcode = scannedUrl;
                  });
                  Navigator.pop(context); // Close the dialog after scanning
                  _launchUrl(scannedUrl); // Open the scanned URL
                }
              },
            ),
          ),
        );
      },
    );
  }

  // Function to open the URL in the default browser
  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
