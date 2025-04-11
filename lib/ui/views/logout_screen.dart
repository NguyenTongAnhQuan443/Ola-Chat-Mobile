import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/ui/views/login_screen.dart';

import '../../main.dart';
import '../../view_models/login_view_model.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 44,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          onPressed: () {
            _showLogoutDialog(context);
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.black87),
          child: const Text(
            "Đăng xuất",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text(
                        "Hủy",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        final viewModel =
                            Provider.of<LoginViewModel>(context, listen: false);

                        Future.delayed(Duration.zero, () async {
                          try {
                            await viewModel.logout();
                            navigatorKey.currentState?.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          } catch (e) {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text(viewModel.errorMessage ??
                                    'Đăng xuất thất bại'),
                              ),
                            );
                          }
                        });
                      },
                      child: const Text(
                        "Đăng xuất",
                        style: TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
