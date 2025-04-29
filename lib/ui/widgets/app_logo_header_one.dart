import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/constants.dart';

class AppLogoHeaderOne extends StatelessWidget {
  // DÀNH CHO CÁC TRANG ĐĂNG NHẬP ĐĂNG KÝ V.V
  final bool showBackButton;

  const AppLogoHeaderOne({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Stack(
        children: [
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/icons/LogoApp.png',
                  width: AppStyles.logoIconSize,
                  height: AppStyles.logoIconSize,
                ),
                const SizedBox(width: 18),
                const Text(AppStyles.nameApp, style: AppStyles.socialTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
