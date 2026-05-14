import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto/core/router/app_router.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/app_bottom_nav_bar.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/core/widgets/mic_button.dart';
import 'package:proyecto/features/transcriptions/presentation/providers/library_provider.dart';
import 'package:proyecto/features/transcriptions/presentation/widgets/recent_item.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();

  static const _iconColors = [
    AppColors.purple,
    AppColors.teal,
    AppColors.blue,
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pink
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(libraryProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryProvider);

    return BaseScreen(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: 8),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
          // Navbar + mic flotantes
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: AppBottomNavBar(
                    currentIndex: 1,
                    onTap: (index) {
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

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Text(
        'Tu biblioteca',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (q) => ref.read(libraryProvider.notifier).search(q),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Buscar en tus notas...',
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(Icons.search, color: AppColors.textHint, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LibraryState state) {
    return switch (state) {
      LibraryLoading() => const Center(
        child: CircularProgressIndicator(color: AppColors.purple),
      ),
      LibraryError(:final message) => _buildError(message),
      LibraryLoaded() => _buildList(state),
    };
  }

  Widget _buildList(LibraryLoaded state) {
    final items = state.filtered;

    if (items.isEmpty) {
      return Center(
        child: Text(
          state.query.isEmpty
              ? 'Aún no tienes notas grabadas'
              : 'Sin resultados para "${state.query}"',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        final color = _iconColors[index % _iconColors.length];
        final createdAt = DateTime.parse(item['created_at'] as String);
        final duration = Duration(seconds: item['duration_seconds'] as int);

        return RecentItem(
          iconColor: color,
          title: item['title'] as String,
          date: _formatDate(createdAt),
          duration: _formatDuration(duration),
          onTap: () => context.go('${AppRoutes.detail}/${item['id']}'),
          tag: '',
          tagColor: null,
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.red, size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => ref.read(libraryProvider.notifier).load(),
            child: const Text(
              'Reintentar',
              style: TextStyle(color: AppColors.purple),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ayer';
    const months = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${months[date.month]}';
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
