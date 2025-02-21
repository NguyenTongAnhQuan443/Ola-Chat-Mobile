import 'package:flutter/material.dart';

import 'account_settings_screen.dart';
import 'general_settings_screen.dart';
import 'logout_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          // TabBar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            dividerColor: Colors.white,
            tabs: [
              Tab(text: "General"),
              Tab(text: "Account"),
              Tab(text: "Logout"),
            ],
          ),

          // Content TabBar
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                GeneralSettingsScreen(),
                AccountSettingsScreen(),
                LogoutScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
