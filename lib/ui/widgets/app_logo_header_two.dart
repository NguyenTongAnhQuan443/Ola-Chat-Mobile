import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';
import '../views/list_conversation_screen.dart';

class AppLogoHeaderTwo extends StatelessWidget {
  final bool showMessageIcon;

  const AppLogoHeaderTwo({
    super.key,
    this.showMessageIcon = true, // mặc định là hiện icon
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: Row(
                children: [
                  Image.asset('assets/icons/LogoApp.png',
                      width: AppStyles.logoIconSize,
                      height: AppStyles.logoIconSize),
                  const SizedBox(width: 18),
                  const Text(AppStyles.nameApp,
                      style: AppStyles.socialTextStyle),
                ],
              ),
            ),

            // Chỉ hiển thị icon nếu showMessageIcon là true
            if (showMessageIcon)
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListConversationScreen()));
                },
                child: Image.asset(
                  'assets/icons/Send.png',
                  width: 20,
                  height: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
