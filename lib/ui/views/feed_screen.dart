import 'package:flutter/material.dart';
import 'package:olachat_mobile/core/utils/constants.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Expanded(
              flex: 1,

              // View 1 - Header
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/LogoApp.png',
                              width: AppStyles.logoIconSize,
                              height: AppStyles.logoIconSize),
                          const SizedBox(width: 18),
                          Text("Social", style: AppStyles.socialTextStyle),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                      child: Image.asset('assets/icons/Send.png',
                          width: 20, height: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            // View 2 - Post 
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.yellow,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
