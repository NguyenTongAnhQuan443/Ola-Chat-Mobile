import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:olachat_mobile/ui/views/user_profile_info.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/social_header.dart';
import '../../view_models/search_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header
          SocialHeader(),
          CustomSliverToBoxAdapter(),

          // TextField search
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      viewModel.searchUser(value); // gọi API
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    hintText: "Số điện thoại hoặc email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),

          CustomSliverToBoxAdapter(),

          // Loading
          if (viewModel.isLoading)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B4FE1)), // màu xanh hiện đại
                    ),
                  ),

                ),
              ),
            ),

          // Kết quả tìm thấy
          if (viewModel.result != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: (viewModel.result?.avatar != null && viewModel.result!.avatar.isNotEmpty)
                          ? NetworkImage(viewModel.result!.avatar)
                          : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                    ),
                    title: Text(
                      viewModel.result!.displayName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.result!.nickname),
                        SizedBox(height: 4),
                        Text(viewModel.result!.bio,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_outlined),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UserProfileInfoScreen(user: viewModel.result!),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // Lỗi hoặc không tìm thấy
          if (viewModel.error != null)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/SEO-pana.svg',
                      height: 400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2D2D2D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Hãy thử lại với số điện thoại hoặc email khác nhé.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A7A7A), // nhẹ nhàng hơn
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
