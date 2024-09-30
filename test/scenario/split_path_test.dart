import 'package:dev_studio/client/src/scenario_runner/runtime/path_tracker.dart';
import 'package:test/test.dart';

void main() {
  test('Path tracker simple', () {
    var tracker = PathTracker();
    expect(tracker.id, [0]);
    expect(tracker.split(3), 0);
    expect(tracker.id, [0, 0]);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 1);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 2);
    expect(tracker.resetAndCheck(), isFalse);
  });

  test('Path tracker nested', () {
    var tracker = PathTracker();
    expect(tracker.split(3), 0);
    expect(tracker.split(2), 0);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 0);
    expect(tracker.split(2), 1);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 1);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 2);
    expect(tracker.split(4), 0);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 2);
    expect(tracker.split(4), 1);
    expect(tracker.id, [0, 2, 1]);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 2);
    expect(tracker.split(4), 2);
    expect(tracker.resetAndCheck(), isTrue);
    expect(tracker.split(3), 2);
    expect(tracker.split(4), 3);
    expect(tracker.resetAndCheck(), isFalse);
  });
}
