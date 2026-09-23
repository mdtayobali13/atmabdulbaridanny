import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/providers/admin_providers.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/widgets/admin_access_denied_view.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/widgets/tabs/admin_about_me_tab.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/widgets/tabs/admin_contact_tab.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/widgets/tabs/admin_overview_tab.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/widgets/tabs/admin_requests_tab.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/widgets/tabs/admin_users_tab.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/app_drawer.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

// Export shared admin providers for backward compatibility
export 'package:atmabdulbaridanny/screens/admin_screen/providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    ref.invalidate(adminDashboardProvider);
    ref.invalidate(adminCitizenRequestsProvider);
    ref.invalidate(adminUsersListProvider);
    ref.invalidate(adminContactListProvider);
    ref.invalidate(adminAboutMeListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null || user.id == null) {
          return AdminAccessDeniedView(
            isBangla: isBangla,
            primaryColor: primaryGreen,
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FA),
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: Text(
              isBangla ? "অ্যাডমিন প্যানেল" : "Admin Panel",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            backgroundColor: primaryGreen,
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                tooltip: isBangla ? "মেনু" : "Menu",
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                tooltip: isBangla ? "রিফ্রেশ" : "Refresh",
                onPressed: _refreshAll,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.instance.goldenColor,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(
                  icon: const Icon(CupertinoIcons.chart_pie, size: 18),
                  text: isBangla ? "ড্যাশবোর্ড" : "Overview",
                ),
                Tab(
                  icon: const Icon(CupertinoIcons.doc_plaintext, size: 18),
                  text: isBangla ? "আবেদন" : "Requests",
                ),
                Tab(
                  icon: const Icon(CupertinoIcons.person_2, size: 18),
                  text: isBangla ? "ইউজার" : "Users",
                ),
                Tab(
                  icon: const Icon(CupertinoIcons.mail, size: 18),
                  text: isBangla ? "যোগাযোগ" : "Contact",
                ),
                Tab(
                  icon: const Icon(CupertinoIcons.person_crop_circle, size: 18),
                  text: isBangla ? "আমার সম্পর্কে" : "About Me",
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              AdminOverviewTab(isBangla: isBangla, onRefresh: _refreshAll),
              AdminRequestsTab(isBangla: isBangla, onRefresh: _refreshAll),
              AdminUsersTab(isBangla: isBangla, onRefresh: _refreshAll),
              AdminContactTab(isBangla: isBangla, onRefresh: _refreshAll),
              AdminAboutMeTab(isBangla: isBangla, onRefresh: _refreshAll),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF7F9FA),
        appBar: AppBar(
          title: Text(
            isBangla ? "অ্যাডমিন প্যানেল" : "Admin Panel",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: primaryGreen,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => AdminAccessDeniedView(
        isBangla: isBangla,
        primaryColor: primaryGreen,
      ),
    );
  }
}
