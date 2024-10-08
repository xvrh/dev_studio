import 'dart:async';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../client/internal.dart';
import '../../client/scenario.dart';

class Server {
  static const defaultPort = defaultServerPort;

  late HttpServer _server;
  final _clients = BehaviorSubject<List<ScenarioApi>>.seeded([]);

  Server._();

  static Future<Server> start({int? port}) async {
    var server = Server._();
    await server._init(port: port);
    return server;
  }

  Future<void> _init({int? port}) async {
    port ??= defaultPort;

    var router = Router();
    router.get('/socket', _scenarioSocketHandler);

    _server = await io.serve(router.call, InternetAddress.anyIPv4, port);
    _server.defaultResponseHeaders.set('Access-Control-Allow-Origin', '*');

    print('Server started ws://${_server.address.host}:${_server.port}');
  }

  FutureOr<Response> _scenarioSocketHandler(Request request) {
    return webSocketHandler((WebSocketChannel channel) =>
        _onScenarioConnect(request, channel))(request);
  }

  void _onScenarioConnect(Request request, WebSocketChannel channel) async {
    late ScenarioApi client;
    client = ScenarioApi(channel.cast<String>(), onClose: () {
      _clients.add(_clients.value..remove(client));
    });

    _clients.add(_clients.value..add(client));
  }

  ValueStream<List<ScenarioApi>> get clients => _clients;

  void dispose() {
    _clients.close();
  }
}
