import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/bus_schedule.dart';
import '../../viewmodels/schedule_viewmodel.dart';

class ScheduleList extends ConsumerWidget {
  const ScheduleList({
    super.key,
    required this.timetable,
    required this.direction,
  });

  final BusTimetable timetable;
  final BusDirection direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(countdownProvider);

    final buses = timetable.todayBuses(direction);
    final nextBus = timetable.nextBus(direction, now: now);

    if (buses.isEmpty) {
      return const Center(
        child: Text(
          '時刻表データなし',
          style: TextStyle(color: Color(0xFF666666)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: buses.length,
      itemBuilder: (context, index) {
        final bus = buses[index];
        final isPast = bus.minutesFromNow(now: now) < 0;
        final isNext = nextBus != null && bus.time == nextBus.time;
        return _ScheduleRow(bus: bus, isPast: isPast, isNext: isNext);
      },
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.bus,
    required this.isPast,
    required this.isNext,
  });

  final BusEntry bus;
  final bool isPast;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final Color textColor;
    final Color bgColor;

    if (isNext) {
      textColor = const Color(0xFF0A0A0A);
      bgColor = const Color(0xFF00FF88);
    } else if (isPast) {
      textColor = const Color(0xFF444444);
      bgColor = Colors.transparent;
    } else {
      textColor = const Color(0xFFCCCCCC);
      bgColor = Colors.transparent;
    }

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            bus.time,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            bus.destination,
            style: TextStyle(color: textColor, fontSize: 14, letterSpacing: 1),
          ),
          if (isNext) ...[
            const Spacer(),
            const Text(
              '◀ NEXT',
              style: TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
