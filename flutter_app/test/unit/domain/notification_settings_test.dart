import 'package:flutter_test/flutter_test.dart';
import 'package:chitose_bus/domain/entities/bus_schedule.dart';
import 'package:chitose_bus/domain/entities/notification_settings.dart';

void main() {
  group('NotificationSettings', () {
    test('デフォルト値: enabled=false, minutesBefore=10, direction=null', () {
      const s = NotificationSettings();
      expect(s.enabled, isFalse);
      expect(s.minutesBefore, 10);
      expect(s.direction, isNull);
    });

    test('copyWith: enabled のみ変更', () {
      const s = NotificationSettings();
      final s2 = s.copyWith(enabled: true);
      expect(s2.enabled, isTrue);
      expect(s2.minutesBefore, 10);
      expect(s2.direction, isNull);
    });

    test('copyWith: minutesBefore のみ変更', () {
      const s = NotificationSettings(enabled: true, minutesBefore: 10);
      final s2 = s.copyWith(minutesBefore: 5);
      expect(s2.minutesBefore, 5);
      expect(s2.enabled, isTrue);
    });

    test('copyWith: direction を設定', () {
      const s = NotificationSettings();
      final s2 = s.copyWith(direction: BusDirection.fromChitose);
      expect(s2.direction, BusDirection.fromChitose);
    });

    test('copyWith: clearDirection=true で direction を null に', () {
      const s = NotificationSettings(direction: BusDirection.fromChitose);
      final s2 = s.copyWith(clearDirection: true);
      expect(s2.direction, isNull);
    });

    test('minutesOptions に 5/10/15/30 が含まれる', () {
      expect(NotificationSettings.minutesOptions, containsAll([5, 10, 15, 30]));
    });

    test('== と hashCode: 同じ値は等しい', () {
      const a = NotificationSettings(enabled: true, minutesBefore: 5, direction: BusDirection.fromChitose);
      const b = NotificationSettings(enabled: true, minutesBefore: 5, direction: BusDirection.fromChitose);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
