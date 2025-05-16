// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:olachat_mobile/view_models/friend_request_view_model.dart';
// import 'package:olachat_mobile/ui/widgets/app_logo_header_one.dart';
//
// class AllFriendRequestsScreen extends StatefulWidget {
//   const AllFriendRequestsScreen({super.key});
//
//   @override
//   State<AllFriendRequestsScreen> createState() =>
//       _AllFriendRequestsScreenState();
// }
//
// class _AllFriendRequestsScreenState extends State<AllFriendRequestsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<FriendRequestViewModel>(context, listen: false)
//             .fetchReceivedRequests());
//   }
//
//   void _goToProfile(BuildContext context, String userId) {
//     Navigator.pushNamed(context, '/profile', arguments: userId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<FriendRequestViewModel>(context);
//     final userIds = vm.receivedRequestIds.toList();
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Padding(
//           padding: const EdgeInsets.only(top: 0),
//           child: Column(
//             children: [
//               const AppLogoHeaderOne(showBackButton: true),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Tất cả lời mời kết bạn",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: userIds.isEmpty
//                     ? const Center(
//                   child: Text("Không có lời mời kết bạn nào"),
//                 )
//                     : ListView.builder(
//                   itemCount: userIds.length,
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   itemBuilder: (context, index) {
//                     final userId = userIds[index];
//                     final displayName = vm.getDisplayName(userId);
//                     final isAccepting =
//                     vm.isButtonLoading(userId, "accept");
//                     final isRejecting =
//                     vm.isButtonLoading(userId, "reject");
//                     final isLoading = isAccepting || isRejecting;
//
//                     final avatar = null; // TODO: gắn avatar nếu có
//
//                     return Card(
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       color: const Color(0xFFF4EDFC),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () => _goToProfile(context, userId),
//                               child: CircleAvatar(
//                                 radius: 24,
//                                 backgroundImage: avatar != null
//                                     ? NetworkImage(avatar)
//                                     : const AssetImage(
//                                     'assets/images/default_avatar.png')
//                                 as ImageProvider,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () =>
//                                     _goToProfile(context, userId),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Text(displayName,
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16)),
//                                     const Text(
//                                       "Đang chờ kết bạn",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: isLoading
//                                       ? null
//                                       : () async {
//                                     vm.setButtonLoading(
//                                         userId, "accept");
//                                     await vm.acceptRequest(
//                                         userId, context);
//                                     vm.setButtonLoading(
//                                         userId, null);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                     const Color(0xFF4B67D3),
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 14, vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(8)),
//                                     textStyle:
//                                     const TextStyle(fontSize: 14),
//                                   ),
//                                   child: isAccepting
//                                       ? const SizedBox(
//                                     width: 16,
//                                     height: 16,
//                                     child:
//                                     CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                       : const Text("Xác nhận"),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 OutlinedButton(
//                                   onPressed: isLoading
//                                       ? null
//                                       : () async {
//                                     vm.setButtonLoading(
//                                         userId, "reject");
//                                     await vm.rejectRequest(
//                                         userId, context);
//                                     vm.setButtonLoading(
//                                         userId, null);
//                                   },
//                                   style: OutlinedButton.styleFrom(
//                                     foregroundColor:
//                                     const Color(0xFF4B67D3),
//                                     side: const BorderSide(
//                                         color: Color(0xFF4B67D3)),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 14, vertical: 10),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(8)),
//                                     textStyle:
//                                     const TextStyle(fontSize: 14),
//                                   ),
//                                   child: isRejecting
//                                       ? const SizedBox(
//                                     width: 16,
//                                     height: 16,
//                                     child:
//                                     CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                       : const Text("Từ chối"),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
