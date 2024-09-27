import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main() async {
  var handler =
      createStaticHandler('build/scenario', defaultDocument: 'index.html');

  var server = await io.serve(handler, 'localhost', 8082);
  print('Server http://${server.address.host}:${server.port}');
}
