import 'package:dev_studio/src/utils/fitted_app.dart';
import 'package:flutter/material.dart';
import 'package:os_detect/os_detect.dart' as platform;
import 'package:rxdart/rxdart.dart';
import '../../client/internal.dart' show ScenarioApi;
import 'app_connected.dart';
import 'server.dart';
import 'service.dart';

class ScenarioAppWithServer extends StatefulWidget {
  final ScenarioService Function(ValueStream<List<ScenarioApi>>) serviceFactory;

  const ScenarioAppWithServer({
    super.key,
    required this.serviceFactory,
  });

  @override
  State<ScenarioAppWithServer> createState() => _ScenarioAppWithServerState();
}

class _ScenarioAppWithServerState extends State<ScenarioAppWithServer> {
  ScenarioService? _service;

  @override
  void initState() {
    super.initState();

    _startServer();
  }

  void _startServer() async {
    var server = await Server.start();
    if (mounted) {
      setState(() {
        _service = widget.serviceFactory(server.clients);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var service = _service;
    if (service == null) {
      return _LoadingScreen();
    } else {
      return FittedApp(
        minimumSize: Size(750, 400),
        child: ScenarioApp(service),
      );
    }
  }
}

class ScenarioApp extends StatelessWidget {
  final ScenarioService service;

  const ScenarioApp(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScenarioApi>>(
      stream: service.clients,
      initialData: service.clients.value,
      builder: (context, snapshot) {
        var clients = snapshot.requireData;
        if (clients.isEmpty) {
          return _WaitingConnectionScreen();
        } else {
          //TODO(xha): add a tab bar to handle several clients
          var client = clients.last;
          return ConnectedScreen(
            service,
            client,
            key: ValueKey(client),
          );
        }
      },
    );
  }
}

class _WaitingConnectionScreen extends StatelessWidget {
  const _WaitingConnectionScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!platform.isBrowser) ...[
            Text('Waiting for connection...'),
            SelectableText(
                'flutter run -d flutter-tester <scenario-file>.dart'),
            SelectableText('flutter run -d chrome <scenario-file>.dart'),
          ] else ...[
            Text('Loading...'),
          ]
        ],
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text('Starting server...'),
          ],
        ),
      ),
    );
  }
}
