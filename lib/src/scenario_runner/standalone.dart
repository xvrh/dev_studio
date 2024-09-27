import 'package:dev_studio/src/utils/router_outlet.dart';
import 'package:flutter/material.dart';

class StandaloneScenarioApp extends StatelessWidget {
  final Widget app;

  const StandaloneScenarioApp(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    return RouterOutlet.root(
      child: MaterialApp(
        title: 'Scenario runner',
        home: Scaffold(
          backgroundColor: Colors.white,
          body: app,
        ),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
