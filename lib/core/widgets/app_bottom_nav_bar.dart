import 'package:flutter/material.dart';
import 'package:proyecto/core/theme/app_colors.dart';

class NavItem {
  final IconData icon;
  final String? label;
  const NavItem({required this.icon, required this.label});
}

const List<NavItem> navBarItems = [
  NavItem(icon: Icons.home_filled, label: 'Inicio'),
  NavItem(icon: Icons.list, label: 'Notas'),
  NavItem(icon: Icons.person_outlined, label: 'Perfil'),
];

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(color: Colors.white.withAlpha(55), width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: navBarItems.asMap().entries.map((entry) {
                int index = entry.key;
                NavItem item = entry.value;

                return _buildNavItem(
                  item: item,
                  isSelected: currentIndex == index,
                  onTap: () => onTap(index),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required NavItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? Colors.white : Colors.white.withAlpha(55),
              size: 24,
            ),
            if (item.label != null) ...[
              const SizedBox(height: 2),
              Text(
                item.label!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withAlpha(80),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
