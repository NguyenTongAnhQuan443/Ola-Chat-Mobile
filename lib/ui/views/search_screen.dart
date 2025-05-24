import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:olachat_mobile/ui/widgets/custom_sliver_to_box_adapter.dart';
import 'package:olachat_mobile/ui/widgets/app_logo_header_two.dart';
import '../../view_models/search_view_model.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.clearSearchResult();
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header
          AppLogoHeaderTwo(),
          CustomSliverToBoxAdapter(),

          // TextField search
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        viewModel.searchUser(
                            value); // gọi API sau 500ms nếu user ngừng gõ
                      }
                    });
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2B4FE1)),
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
                      backgroundImage: (viewModel.result?.avatar != null &&
                              viewModel.result!.avatar.isNotEmpty)
                          ? NetworkImage(viewModel.result!.avatar)
                          : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                    ),
                    title: Text(
                      viewModel.result!.displayName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.result!.nickname ?? ''),
                        SizedBox(height: 4),
                        Text(viewModel.result!.bio ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_outlined),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => UserProfileInfomationScreen(
                    //           user: viewModel.result!),
                    //     ),
                    //   );
                    // },
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
                        color: Color(0xFF7A7A7A),
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
