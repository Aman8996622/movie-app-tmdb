import 'package:flutter/material.dart';
import 'package:movieapp/presentation/widget/scan_qr.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({
    super.key,
  });

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Offer QR Code'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Align the QR code\nwithin the frame to scan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const ScanQrBox(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
