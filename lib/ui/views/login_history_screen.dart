import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:olachat_mobile/core/utils/constants.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header.dart';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/view_models/login_history_view_model.dart';
import 'package:olachat_mobile/view_models/login_view_model.dart';

class LoginHistoryScreen extends StatelessWidget {
  const LoginHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<LoginViewModel>(context, listen: false)
        .userInfo?['userId'];

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Không thể xác định userId")),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => LoginHistoryViewModel()..fetchHistory(userId),
      child: Consumer<LoginHistoryViewModel>(
        builder: (context, vm, _) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    AppLogoHeader(showBackButton: false),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Lịch sử đăng nhập',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SvgPicture.asset(
                      'assets/images/undraw_hello_ccwj.svg', // đảm bảo có ảnh này
                      height: 180,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: vm.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : vm.error != null
                          ? Center(
                        child: Text(
                          vm.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                          : ListView.separated(
                        itemCount: vm.items.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = vm.items[index];
                          final loginTime = DateFormat('HH:mm dd/MM/yyyy')
                              .format(DateTime.parse(item.loginTime));
                          final logoutTime = item.logoutTime != null
                              ? DateFormat('HH:mm dd/MM/yyyy')
                              .format(DateTime.parse(item.logoutTime!))
                              : '---';

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                  Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.devices,
                                    size: 28,
                                    color: Colors.indigo.shade400),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.userAgent,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.login,
                                              size: 16,
                                              color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Login: $loginTime',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color:
                                                Colors.black87),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.logout,
                                              size: 16,
                                              color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Logout: $logoutTime',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color:
                                                Colors.black87),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 10,
                                              color: item.status ==
                                                  "ONLINE"
                                                  ? Colors.green
                                                  : Colors.grey),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Trạng thái: ${item.status}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.w500,
                                              color: item.status ==
                                                  "ONLINE"
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Quay lại",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
