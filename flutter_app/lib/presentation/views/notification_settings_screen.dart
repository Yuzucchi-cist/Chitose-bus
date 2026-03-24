import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bus_schedule.dart';
import '../../domain/entities/notification_settings.dart';
import '../viewmodels/notification_viewmodel.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  static const _directionLabels = {
    BusDirection.fromChitose: '千歳駅発',
    BusDirection.fromMinamiChitose: '南千歳発',
    BusDirection.fromKenkyutoToHonbuto: '研究棟発（→本部棟方面）',
    BusDirection.fromKenkyutoToStation: '研究棟発 → 千歳駅',
    BusDirection.fromHonbuto: '本部棟発',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: const Color(0xFF00FF88),
        title: const Text(
          '通知設定',
          style: TextStyle(
            color: Color(0xFF00FF88),
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
      ),
      body: settingsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00FF88)),
        ),
        error: (e, _) => Center(
          child: Text('エラー: $e',
              style: const TextStyle(color: Color(0xFFFF4444))),
        ),
        data: (settings) => _SettingsBody(settings: settings),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.settings});

  final NotificationSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Enable toggle
        _SectionCard(
          child: SwitchListTile(
            title: const Text(
              '出発通知を有効にする',
              style: TextStyle(color: Color(0xFFCCCCCC), letterSpacing: 1),
            ),
            subtitle: const Text(
              '次のバスが出発する前に通知を受け取ります',
              style: TextStyle(color: Color(0xFF666666), fontSize: 12),
            ),
            value: settings.enabled,
            activeThumbColor: const Color(0xFF00FF88),
            onChanged: (v) => v
                ? notifier.enableNotifications(settings)
                : notifier.saveSettings(settings.copyWith(enabled: false)),
          ),
        ),
        const SizedBox(height: 16),

        // Minutes before
        _SectionCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '通知タイミング',
                  style: TextStyle(
                      color: Color(0xFF00FF88),
                      fontSize: 12,
                      letterSpacing: 2),
                ),
                const SizedBox(height: 12),
                DropdownButton<int>(
                  value: settings.minutesBefore,
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(
                      color: Color(0xFFCCCCCC), fontSize: 16),
                  isExpanded: true,
                  underline: const Divider(color: Color(0xFF333333)),
                  items: NotificationSettings.minutesOptions
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text('$m 分前'),
                          ))
                      .toList(),
                  onChanged: settings.enabled
                      ? (v) => notifier.saveSettings(
                          settings.copyWith(minutesBefore: v ?? 10))
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Direction
        _SectionCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '通知する路線',
                  style: TextStyle(
                      color: Color(0xFF00FF88),
                      fontSize: 12,
                      letterSpacing: 2),
                ),
                const SizedBox(height: 12),
                DropdownButton<BusDirection?>(
                  value: settings.direction,
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(
                      color: Color(0xFFCCCCCC), fontSize: 14),
                  isExpanded: true,
                  underline: const Divider(color: Color(0xFF333333)),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('選択してください',
                          style: TextStyle(color: Color(0xFF666666))),
                    ),
                    ...BusDirection.values.map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(NotificationSettingsScreen
                              ._directionLabels[d]!),
                        )),
                  ],
                  onChanged: settings.enabled
                      ? (v) => v == null
                          ? notifier.saveSettings(
                              settings.copyWith(clearDirection: true))
                          : notifier.saveSettings(settings.copyWith(direction: v))
                      : null,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        if (settings.enabled && settings.direction == null)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '通知を受け取るには路線を選択してください',
              style: TextStyle(color: Color(0xFFFFB000), fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF222222)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
