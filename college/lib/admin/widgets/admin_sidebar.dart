import 'package:college/admin/admin_dashboard.dart';
import 'package:college/admin/widgets/sidebar_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminSideBar extends StatelessWidget {
  final String? id;
  final String? adminEmail;
  final String? adminName;

  const AdminSideBar({
    super.key,
    this.id,
    this.adminName,
    this.adminEmail,
  });

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController dashboardController = Get.find();
    return Container(
      width: 275,
      color: Colors.transparent,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Iconsax.user_tick, size: 60, color: Colors.white), onPressed: (){}),
                const SizedBox(height: 10),
    
                // Admin Name and Email
                Text(adminName??'No Name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(adminEmail??'No Email', style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          SidebarTile(icon: Iconsax.global, title: 'Website', onTap: ()=>dashboardController.setCurrentView('Website')),
          SidebarTile(icon: Iconsax.user, title: 'Student', onTap: ()=>dashboardController.setCurrentView('Student')),
          SidebarTile(icon: Iconsax.teacher, title: 'Faculty', onTap: ()=>dashboardController.setCurrentView('Faculty')),
          SidebarTile(icon: Iconsax.bookmark, title: 'Courses', onTap: ()=>dashboardController.setCurrentView('Courses')),
          SidebarTile(icon: Iconsax.card, title: 'Fees', onTap: ()=>dashboardController.setCurrentView('Fees')),
          SidebarTile(icon: Iconsax.book, title: 'Library', onTap: ()=>dashboardController.setCurrentView('Library')),
          SidebarTile(icon: Iconsax.house, title: 'Hostel', onTap: ()=>dashboardController.setCurrentView('Hostel')),
          SidebarTile(icon: Iconsax.message_question, title: 'Feedback', onTap: ()=>dashboardController.setCurrentView('Feedback')),
          SidebarTile(icon: Iconsax.briefcase, title: 'Placements', onTap: (){dashboardController.setCurrentView('Placements');}),
          SidebarTile(icon: Iconsax.user_octagon, title: 'Alumni Network', onTap: (){dashboardController.setCurrentView('Alumni');}),
        ],
      ),
    );
  }
}