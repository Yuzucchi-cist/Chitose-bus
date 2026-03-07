import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitose_bus/presentation/viewmodels/schedule_viewmodel.dart';

void main() {
  group('CountdownNotifier', () {
    test('initial state is close to DateTime.now()', () {
      final before = DateTime.now();
      final notifier = CountdownNotifier();
      addTearDown(notifier.dispose);
      final after = DateTime.now();

      expect(
        notifier.state.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(notifier.state.isBefore(after.add(const Duration(seconds: 1))), isTrue);
    });

    test('state updates after countdownRefreshInterval elapses', () {
      fakeAsync((async) {
        final notifier = CountdownNotifier();
        final initial = notifier.state;

        // Advance fake clock by 30 seconds (countdownRefreshInterval)
        async.elapse(const Duration(seconds: 30));

        expect(notifier.state.isAfter(initial), isTrue);
        notifier.dispose();
      });
    });

    test('state does not update before interval elapses', () {
      fakeAsync((async) {
        final notifier = CountdownNotifier();
        final initial = notifier.state;

        // Advance by less than the interval
        async.elapse(const Duration(seconds: 29));

        expect(notifier.state, equals(initial));
        notifier.dispose();
      });
    });

    test('state updates multiple times over multiple intervals', () {
      fakeAsync((async) {
        final notifier = CountdownNotifier();
        final initialState = notifier.state;

        // Verify each of 3 successive intervals triggers a state update.
        async.elapse(const Duration(seconds: 30));
        final stateAfter1 = notifier.state;
        expect(stateAfter1.isAfter(initialState), isTrue); // 1st update

        async.elapse(const Duration(seconds: 30));
        final stateAfter2 = notifier.state;
        expect(stateAfter2.isAfter(stateAfter1), isTrue); // 2nd update

        async.elapse(const Duration(seconds: 30));
        final stateAfter3 = notifier.state;
        expect(stateAfter3.isAfter(stateAfter2), isTrue); // 3rd update

        notifier.dispose();
      });
    });
  });
}
