import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/widgets/app_bottom_nav_bar.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/core/widgets/mic_button.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const SafeArea(
            child: Center(
              child: Text(
                'Library',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: AppBottomNavBar(
                    currentIndex: 1,
                    onTap: (int index) {
                      switch (index) {
                        case 0:
                          context.go(AppRoutes.dashboard);
                        case 1:
                          context.go(AppRoutes.library);
                        case 2:
                          context.go(AppRoutes.profile);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                MicButton(
                  onTap: () => context.go(AppRoutes.recording),
                  width: 55,
                  height: 55,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
