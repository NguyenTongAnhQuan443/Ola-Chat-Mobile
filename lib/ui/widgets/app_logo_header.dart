import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/constants.dart';

class AppLogoHeader extends StatelessWidget {
  final bool showBackButton;

  const AppLogoHeader({super.key, this.showBackButton = false});

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
                const Text("Social", style: AppStyles.socialTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
