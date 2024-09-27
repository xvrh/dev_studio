import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    var pages = [
      Page1(),
      Page2(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: pages,
            ),
          ),
          FilledButton(
            onPressed: () {
              _controller.animateToPage(
                  (_controller.page!.round() + 1) % pages.length,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut);
            },
            child: Text('NEXT'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Icon(
          Icons.warning,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: Icon(
          Icons.description,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
