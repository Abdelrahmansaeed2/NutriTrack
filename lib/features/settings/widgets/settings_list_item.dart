import 'package:flutter/material.dart';
import 'package:nutri_track/core/theme/app_theme.dart';

class SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;

  const SettingsListItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.isDestructive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.1)
                : AppTheme.primaryBrandColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppTheme.primaryBrandColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDestructive ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w400,
                ),
              )
            : null,
        trailing: trailing ??
            (isDestructive
                ? null
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  )),
        onTap: onTap,
      ),
    );
  }
}
