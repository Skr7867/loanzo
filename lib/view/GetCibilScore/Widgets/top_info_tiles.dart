import 'package:flutter/material.dart';

import '../../../res/fonts/app_fonts.dart';

class TopInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color valueColor;

  const TopInfoTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: valueColor),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: valueColor,
              fontFamily: AppFonts.opensansRegular,
            ),
          ),
        ],
      ),
    );
  }
}
