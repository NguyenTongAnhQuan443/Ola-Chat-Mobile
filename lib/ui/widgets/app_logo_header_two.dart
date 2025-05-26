import 'package:flutter/material.dart';
import 'package:olachat_mobile/utils/app_styles.dart';

import '../views/messages_list_screen.dart';

class AppLogoHeaderTwo extends StatelessWidget {
  // DÀNH CHO CÁC TRANG HOME KHI ĐĂNG NHẬP THÀNH CÔNG
  const AppLogoHeaderTwo({super.key});

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
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MessagesConversationScreen(),
              //     ),
              //   );
              // },
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessagesListScreen()));
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
