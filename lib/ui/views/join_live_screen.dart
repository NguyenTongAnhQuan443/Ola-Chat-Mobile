import 'package:flutter/material.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart'; // Header bạn cung cấp
import 'live_stream_audience_page.dart';

class JoinLiveScreen extends StatelessWidget {
  const JoinLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppLogoHeaderOne(showBackButton: true),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nhập mã Live ID để xem livestream",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Live ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final liveID = controller.text.trim();
                        if (liveID.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LiveStreamAudiencePage(liveID: liveID),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.live_tv),
                      label: const Text("Xem livestream"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
