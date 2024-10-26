import 'package:flutter/material.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/colors.dart';

class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SidebarTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: TColors.primary,
      contentPadding: const EdgeInsets.all(TSizes.md),
      leading: Icon(icon, color: Colors.lightBlueAccent),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      onTap: onTap,
    );
  }
}