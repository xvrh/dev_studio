import 'package:built_collection/built_collection.dart';
import 'package:dev_studio_core/scenario_models.dart';
import 'package:test/test.dart';

void main() {
  var scenario = ScenarioReference(['Home', 'Login']);
  var run = ScenarioRun(
    scenario,
    RunArgs(
      scenario.name,
      device: DeviceInfo.iPhoneX,
      accessibility: AccessibilityConfig.defaultValue,
      language: 'en',
      imageRatio: 1.0,
    ),
  );

  test('Scenario simple collapse', () {
    run = run.rebuild((r) {
      r.screens['A'] = Screen([], 'A', 'A').rebuild((s) {
        s.next.add(ScreenLink('B'));
      });
      r.screens['B'] = Screen([], 'B', 'B').rebuild((s) {
        s.next.add(ScreenLink('C'));
        s.isCollapsable = true;
      });
      r.screens['C'] = Screen([], 'C', 'C');
    });

    var collapsed = run.collapse();
    expect(collapsed.screens.length, 3);
    expect(
        collapsed.screens['A']!.next, BuiltList<ScreenLink>([ScreenLink('C')]));
    expect(
        collapsed.screens['A']!.collapsedScreens,
        BuiltList([
          Screen([], 'B', 'B', isCollapsable: true).rebuild((b) => b
            ..isCollapsed = true
            ..next.replace([ScreenLink('C')]))
        ]));
    expect(collapsed.screens['B']!.isCollapsed, true);
  });

  test('Scenario double collapse', () {
    run = run.rebuild((r) {
      r.screens['A'] = Screen([], 'A', 'A').rebuild((s) {
        s.next.add(ScreenLink('B'));
      });
      r.screens['B'] = Screen([], 'B', 'B').rebuild((s) {
        s.next.add(ScreenLink('C'));
        s.isCollapsable = true;
      });
      r.screens['C'] = Screen([], 'C', 'C').rebuild((s) {
        s.next.add(ScreenLink('D')
            .rebuild((r) => r.tapRect.replace(Rectangle.fromTLWH(0, 0, 0, 0))));
        s.isCollapsable = true;
      });
      r.screens['D'] = Screen([], 'D', 'D').rebuild((s) {
        s.next.add(ScreenLink('E'));
      });
      r.screens['E'] = Screen([], 'E', 'E');
    });

    var collapsed = run.collapse();
    expect(collapsed.screens.length, 5);
    expect(
        collapsed.screens['A']!.next,
        BuiltList<ScreenLink>([
          ScreenLink('D')
              .rebuild((d) => d.tapRect.replace(Rectangle.fromTLWH(0, 0, 0, 0)))
        ]));
    expect(collapsed.screens['A']!.collapsedScreens, hasLength(2));
  });
}
