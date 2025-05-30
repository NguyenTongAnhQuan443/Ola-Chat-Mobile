import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../view_models/login_qr_view_model.dart';
import '../widgets/app_logo_header_one.dart';

class LoginQrScreen extends StatefulWidget {
  final void Function()? onConfirmSuccess;

  const LoginQrScreen({super.key, this.onConfirmSuccess});

  @override
  State<LoginQrScreen> createState() => _LoginQrScreenState();
}

class _LoginQrScreenState extends State<LoginQrScreen> {
  bool hasScanned = false;

  final MobileScannerController cameraController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar đã được thay bằng AppLogoHeaderOne bên trong body
      body: SafeArea(
        child: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true), // ✅ header nằm trên cùng

            Expanded(
              child: Consumer<LoginQrViewModel>(
                builder: (context, vm, _) {
                  if (vm.deviceInfo != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.devices),
                            title: const Text('Thiết bị'),
                            subtitle: Text(vm.deviceInfo!['deviceName'] ?? 'Không rõ'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.wifi),
                            title: const Text('IP'),
                            subtitle: Text(vm.deviceInfo!['ipAddress'] ?? 'Không rõ'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final success = await vm.confirmLogin(vm.deviceInfo!['confirmUrl']);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('✅ Đã xác nhận đăng nhập')),
                                );

                                await cameraController.stop();
                                await Future.delayed(const Duration(milliseconds: 300));

                                // 👉 Reset lại trạng thái để cho phép quét lại
                                vm.deviceInfo = null;
                                hasScanned = false;
                                vm.notifyListeners();

                                // 👉 Gọi callback nếu có
                                widget.onConfirmSuccess?.call();
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('❌ Xác nhận thất bại')),
                                  );
                                }
                              }
                            },
                            child: const Text("Xác nhận đăng nhập"),
                          ),
                        ],
                      ),
                    );
                  }

                  return MobileScanner(
                    fit: BoxFit.cover,
                    controller: cameraController,
                    onDetect: (capture) async {
                      if (hasScanned) return;
                      hasScanned = true;

                      final barcode = capture.barcodes.first;
                      final rawUrl = barcode.rawValue ?? '';
                      print('📸 Quét được mã: $rawUrl');

                      final uri = Uri.tryParse(rawUrl);
                      final sessionId = uri?.queryParameters['sessionId'];

                      if (sessionId != null) {
                        print('✅ sessionId: $sessionId');
                        await vm.fetchDeviceInfo(sessionId, rawUrl);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('❌ QR không hợp lệ')),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
