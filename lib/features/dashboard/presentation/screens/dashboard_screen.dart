import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/core/theme/app_colors.dart';
import 'package:proyecto/core/widgets/app_bottom_nav_bar.dart';
import 'package:proyecto/core/widgets/base_screen.dart';
import 'package:proyecto/core/widgets/mic_button.dart';
import 'package:proyecto/features/dashboard/presentation/widgets/hero_record_card.dart';
import 'package:proyecto/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:proyecto/features/transcriptions/presentation/widgets/recent_item.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildHeader('Antonio'),
                    SizedBox(height: 24),
                    HeroRecordCard(
                      statusLabel: 'LISTO PARA ESCUCHAR',
                      title: 'Captura tu voz.\nTe devolvemos texto.',
                      onRecord: () {},
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            gradient: RadialGradient(
                              center: Alignment.topLeft,
                              radius: 0.9,
                              colors: [
                                Color.fromARGB(255, 91, 211, 179),
                                Color.fromRGBO(62, 168, 138, 1),
                              ],
                            ),
                            shadow: BoxShadow(
                              color: Color(
                                0xFF5BD3C5,
                              ).withAlpha(60), // mismo color, semi-transparente
                              blurRadius: 10, // qué tan difuso es el glow
                              spreadRadius: 2, // qué tan lejos se expande
                            ),
                            label: 'ESTE MES',
                            value: '4h 12m',
                            description: 'transcritos',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            gradient: RadialGradient(
                              center: Alignment.topLeft,
                              radius: 0.9,
                              colors: [Color(0xff6C95EE), Color(0xff2A4DD5)],
                            ),
                            shadow: BoxShadow(
                              color: Color(
                                0xFF6C95EE,
                              ).withAlpha(60), // mismo color, semi-transparente
                              blurRadius: 10, // qué tan difuso es el glow
                              spreadRadius: 2, // qué tan lejos se expande
                            ),
                            label: 'ESTE MES',
                            value: '4h 12m',
                            description: 'transcritos',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildRecentesHeader(),
                    const SizedBox(height: 12),
                    _buildRecentesList(),
                  ],
                ),
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
                  child: AppBottomNavBar(currentIndex: 0, onTap: (int p1) {}),
                ),
                const SizedBox(width: 12),
                MicButton(onTap: () {}, width: 55, height: 55),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 198, 127, 245),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.person_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recientes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Ver todas >',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentesList() {
    // Mock data — luego vendrá de Supabase
    final items = [
      {
        'title': 'Reunión de equipo Q2',
        'tag': 'Reunión',
        'tagColor': AppColors.purple,
        'iconColor': AppColors.purple,
        'date': 'Hoy, 10:24',
        'duration': '12:48',
      },
      {
        'title': 'Idea para el podcast',
        'tag': 'Idea',
        'tagColor': AppColors.teal,
        'iconColor': AppColors.teal,
        'date': 'Hoy, 08:12',
        'duration': '03:21',
      },
      {
        'title': 'Llamada con Andrés',
        'tag': 'Reunión',
        'tagColor': AppColors.purple,
        'iconColor': AppColors.blue,
        'date': 'Ayer, 17:40',
        'duration': '08:05',
      },
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RecentItem(
                title: item['title'] as String,
                tag: item['tag'] as String,
                tagColor: item['tagColor'] as Color,
                iconColor: item['iconColor'] as Color,
                date: item['date'] as String,
                duration: item['duration'] as String,
                onTap: () {},
              ),
            ),
          )
          .toList(),
    );
  }
}
