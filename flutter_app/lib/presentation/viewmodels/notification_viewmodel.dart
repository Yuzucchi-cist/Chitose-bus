import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notification_settings_repository.dart';
import '../../data/services/local_notification_service.dart';
import '../../domain/entities/bus_schedule.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService.instance,
);

final notificationSettingsRepositoryProvider =
    Provider<NotificationSettingsRepository>(
  (ref) => NotificationSettingsRepository(),
);

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier
    extends AsyncNotifier<NotificationSettings> {
  @override
  Future<NotificationSettings> build() async {
    final repo = ref.watch(notificationSettingsRepositoryProvider);
    return repo.load();
  }

  Future<void> saveSettings(NotificationSettings settings) async {
    final repo = ref.read(notificationSettingsRepositoryProvider);
    await repo.save(settings);
    state = AsyncData(settings);
  }

  Future<void> scheduleForTimetable(BusTimetable timetable) async {
    final settingsState = state;
    if (settingsState is! AsyncData<NotificationSettings>) return;
    final settings = settingsState.value;
    if (!settings.enabled || settings.direction == null) return;

    final service = ref.read(notificationServiceProvider);
    await service.cancelAll();

    final now = DateTime.now();
    final upcomingBuses = timetable
        .schedules
        .where((b) =>
            b.direction == settings.direction &&
            b.toDateTimeToday().isAfter(now))
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    for (final bus in upcomingBuses.take(3)) {
      await service.scheduleNotification(bus, settings);
    }
  }
}
