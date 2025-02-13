import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart';
import 'package:stream_channel/stream_channel.dart';

//ignore_for_file: close_sinks

StreamChannel<String> createWebChannel(Window destinationWindow) {
  var receiveController = StreamController<String>();
  window.onMessage.listen((event) {
    receiveController.add((event.data! as JSString).toDart);
  });

  var sendController = StreamController<String>();
  sendController.stream.listen((String message) {
    destinationWindow.postMessage(message.toJS, '*'.toJS);
  });

  return StreamChannel<String>(receiveController.stream, sendController.sink);
}
