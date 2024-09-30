import 'dart:math';
import 'package:dev_studio/client/scenario.dart';
import 'package:flutter/material.dart';
import 'fake_app.dart';

// Run with: flutter run -d flutter-tester -t test/widget_scenario.dart --hot
/*void main() {
  Runner(
    () => connectToServer(Uri.parse(
        'ws://0.0.0.0:$defaultServerPort/socket?name=widget_scenario')),
    scenarios: allScenarios,
    bundle: () async => IOAssetBundle('build/flutter_assets'),
  );
}*/

void main() => runScenarios(allScenarios,
    projectName: 'WidgetTests', supportedLanguages: ['en', 'fr', 'it']);

Map<String, dynamic> allScenarios() {
  return {
    'Onboarding': OnboardingScenario(),
    'Home': {
      'Login': LoginScenario(),
      'Sign up': LoginScenario(),
    },
    'Path': PathScenario(),
  };
}

class OnboardingScenario extends Scenario {
  @override
  String get description =>
      'Explanations pages describing the features of the app.\n'
      'It appears when you open the app without being authenticated.';

  @override
  Future<void> run() async {
    await pumpWidget(MyApp());
    await pump();
    for (var i = 0; i < 20; i++) {
      await screen('Onboarding page $i !');
      await tap('NEXT');
    }
    await screen('Onboarding page2');
    //await tap('NEXT');
    //await screen('Onboarding page3');
  }
}

class LoginScenario extends Scenario {
  @override
  String get description =>
      'Shows how to authenticate in the app when you already have an account';

  @override
  Future<void> run() async {
    var colors = [
      Colors.green,
      Colors.pink,
      Colors.yellow,
      Colors.blueGrey,
      Colors.lime,
      Colors.indigoAccent
    ];
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: colors[Random().nextInt(colors.length)],
              appBar: AppBar(
                title: Text('Login here'),
                leading: Icon(Icons.error),
                actions: [Icon(Icons.language)],
              ),
              body: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
    await screen('Login');
  }
}

class PathScenario extends Scenario {
  @override
  Future<void> run() async {
    await pumpWidget(MaterialApp(home: HomePage()));
    await screen('Home');

    await screen('Home 2');

    await split({
      'page1': () async {
        await tap('Go page 1');
        await screen('Page 1');
      },
      'page2': () async {
        await tap('Go page 2');
        await screen('Page 2');

        await split({
          'back': () async {
            await back();
            await screen('Home after back');
          },
          'page1': () async {
            await tap('Go page 1');
            await screen('Page 1 after page 2');
          },
        });
      },
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Home page'),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Page1()),
                );
              },
              child: Text('Go page 1'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Page2()));
              },
              child: Text('Go page 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page1'),
      ),
      body: Center(
        child: Text(
          'Page1',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Page 2',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Page1()));
              },
              child: Text('Go page 1'),
            ),
          ],
        ),
      ),
    );
  }
}
