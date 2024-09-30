import 'dart:async';
import 'dart:convert';
import 'dart:io';

//TODO(xha): take this version: https://raw.githubusercontent.com/flutter/flutter/master/packages/flutter_tools/test/src/fake_http_client.dart?

// ignore_for_file: close_sinks
// ignore_for_file: avoid_setters_without_getters

/// Fakes a server response for the [FakeHttpClient].
typedef RequestCallback = FutureOr<FakeHttpResponse> Function(
    HttpClientRequest, FakeHttpClient);

/// A fake [HttpClient] for testing Flutter or Dart VM applications.
///
/// Using [HttpOverrides.global] and an [HttpTestClient], you can test code which
/// uses [HttpClient()] without dependency injection. All you need to do
/// is create a test client and specify how you want it to respond using a
/// [RequestCallback].
///
/// Currently the test client only supports the following HTTP methods:
///
///   * [getUrl]
///   * [postUrl]
///   * [headUrl]
///   * [patchUrl]
///   * [deleteUrl]
///   * [openUrl]
///   * [patchUrl]
///
/// Any of the non *Url methods will throw.  The other members from the
/// http client can be read in the [RequestCallback] but won't be used
/// otherwise. Currently [close], [addCredentials] and [addProxyCredentials]
/// do nothing.
///
/// The following example forces all HTTP requests to return a
/// successful empty response.
///
///     class MyHttpOverrides extends HttpOverrides {
///       HttpClient() createClient(_) {
///         return HttpTestClient((HttpRequest request, HttpTestClient client) {
///           return HttpTestResponse();
///         });
///       }
///     }
///
///     void main() {
///       // overrides all HttpClients.
///       HttpOverrides.global = MyHttpOverrides();
///
///       group('Widget tests', () {
///         test('returns 200', () async {
///            // this is actually an instance of [HttpTestClient].
///            final client = HttpClient();
///            final request = client.getUrl(Uri.https('google.com'));
///            final response = await request.close();
///
///            expect(response.statusCode, HttpStatus.OK);
///         });
///       });
///     }
///
/// If you don't want to override all HttpClients, you can also use
/// [HttpOverrides.runZoned].  Anything which executes in the provided callback
/// will use the provided http client.
///
/// See also:
///
///   * [HttpClient]
///   * [FakeHttpResponse]
///   * [HttpOverrides]
class FakeHttpClient implements HttpClient {
  FakeHttpClient(this._requestCallback);

  final RequestCallback _requestCallback;

  @override
  bool autoUncompress = true;

  @override
  Duration idleTimeout = const Duration(seconds: 120);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) {}

  @override
  void addProxyCredentials(
      String host, int port, String realm, HttpClientCredentials credentials) {}

  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String realm)? f) {}

  @override
  set authenticateProxy(
      Future<bool> Function(String host, int port, String scheme, String realm)?
          f) {}

  @override
  set findProxy(String Function(Uri url)? f) {}

  @override
  set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)? callback) {}

  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      'DELETE',
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      'GET',
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      'HEAD',
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      method.toUpperCase(),
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      'PATCH',
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      'POST',
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    throw UnsupportedError('');
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    final HttpClientRequest response = HttpTestClientRequest._(
      this,
      'PUT',
      url,
      HttpTestHeaders.__(<String, List<String>>{}),
    );
    return Future.value(response);
  }

  @override
  Duration? connectionTimeout;

  @override
  set connectionFactory(
      Future<ConnectionTask<Socket>> Function(
              Uri url, String? proxyHost, int? proxyPort)?
          f) {}

  @override
  set keyLog(Function(String line)? callback) {}
}

/// A fake [HttpClientResponse] to return in a [RequestCallback].
///
/// A test response can be created with [HttpTestResponse()]. This allows
/// you to specify the body, [statusCode], and [headers].
/// Other properties of a [HttpClientResponse] are faked are not currently
/// customizable:
///   * [contentLength] is calculated based on the provided body size.
///   * [redirects] and [cookies] are always the empty list.
///   * [reasonPhrase], [certificate], and [connectionInfo] are always `null`.
///   * [isRedirect] and [persistentConnection] are always false.
///
/// The methods [redirect] and [detachSocket] throw an [UnsupportedError] if
/// called.
///
/// See also:
///
///   * [HttpTestClient]
///   * [HttpClient]
class FakeHttpResponse extends Stream<List<int>> implements HttpClientResponse {
  /// Creates a test response.
  ///
  /// The response [body] can be either a `String`, which will be utf8 encoded,
  /// or a `List<int>` - including `Uint8List` and other typed data objects.
  /// It defaults to the empty string, and will never be `null`;
  ///
  /// The [statusCode] defaults to [HttpStatus.ok].
  ///
  /// [headers] are empty by default.  Multiple header values can be passed
  /// in a comma-separated string.
  factory FakeHttpResponse({
    dynamic body,
    int statusCode = HttpStatus.ok,
    Map<String, String> headers = const <String, String>{},
  }) {
    body ??= '';
    assert(body is String || body is List<int>);
    List<int> codeUnits;
    if (body is String) {
      codeUnits = utf8.encode(body);
    } else {
      codeUnits = body as List<int>;
    }
    final HttpHeaders testHeaders = HttpTestHeaders._(headers);
    return FakeHttpResponse._(codeUnits, statusCode, testHeaders);
  }

  FakeHttpResponse._(
    this._body,
    this._statusCode,
    this._headers,
  );

  final List<int>? _body;
  final int _statusCode;
  final HttpHeaders _headers;

  @override
  final List<RedirectInfo> redirects = <RedirectInfo>[];

  @override
  final List<Cookie> cookies = <Cookie>[];

  @override
  int get statusCode => _statusCode;

  @override
  X509Certificate? get certificate => null;

  @override
  HttpConnectionInfo? get connectionInfo => null;

  @override
  int get contentLength => _body?.length ?? -1;

  @override
  Future<Socket> detachSocket() {
    throw UnsupportedError('');
  }

  @override
  HttpHeaders get headers => _headers;

  @override
  bool get isRedirect => false;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable(<List<int>>[_body ?? const <int>[]])
        .listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => '';

  @override
  Future<HttpClientResponse> redirect(
      [String? method, Uri? url, bool? followLoops]) {
    throw UnsupportedError('');
  }

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
}

/// A fake implementation of [HttpClientRequest].
///
/// It is not necessary to use this class directly. Instead, code should be
/// written as if it is dealing with a regular [HttpHeaders].
///
/// See also:
///
///   * [HttpClientRequest]
class HttpTestClientRequest implements HttpClientRequest {
  HttpTestClientRequest._(
    this._testClient,
    this.method,
    this.uri,
    this.headers,
  );

  final FakeHttpClient _testClient;
  final List<int> _buffer = <int>[];
  final List<Future<void>> _pendingWrites = <Future<void>>[];
  final Completer<HttpClientResponse> _onDone =
      Completer<HttpClientResponse>.sync();
  bool _isClosed = false;

  @override
  Encoding encoding = utf8;

  @override
  final String method;

  @override
  final Uri uri;

  @override
  final HttpHeaders headers;

  @override
  final HttpConnectionInfo? connectionInfo = null;

  @override
  final List<Cookie> cookies = <Cookie>[];

  @override
  void add(List<int> data) {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
    _buffer.addAll(data);
  }

  @override
  void addError(error, [StackTrace? stackTrace]) {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
    final completer = Completer<void>.sync();
    stream.listen(
      (List<int> data) => _buffer.addAll(data),
      onDone: completer.complete,
      cancelOnError: true,
    );
    _pendingWrites.add(completer.future);
    return completer.future;
  }

  @override
  Future<HttpClientResponse> close() async {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
    await Future.wait(_pendingWrites);
    _isClosed = true;
    final response = _testClient._requestCallback(this, _testClient);
    _onDone.complete(response);
    return response;
  }

  @override
  Future<HttpClientResponse> get done => _onDone.future;

  @override
  Future<void> flush() async {
    await Future.wait(_pendingWrites);
  }

  @override
  void write(Object? obj) {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
    final codeUnits = encoding.encode(obj.toString());
    _buffer.addAll(codeUnits);
  }

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) {
    for (var object in objects) {
      write(object);
    }
  }

  @override
  void writeCharCode(int charCode) {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
    _buffer.add(charCode);
  }

  @override
  void writeln([Object? obj = '']) {
    if (_isClosed) {
      throw StateError('writing to a closed HttpRequest');
    }
    write(obj);
    write('\n');
  }

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}

  @override
  bool bufferOutput = false;

  @override
  int contentLength = 0;

  @override
  bool followRedirects = false;

  @override
  int maxRedirects = 10;

  @override
  bool persistentConnection = false;
}

/// A fake implementation of [HttpHeaders].
///
/// It is not necessary to use this class directly. Instead, code should be
/// written as if it is dealing with a regular [HttpHeaders].
///
/// See also:
///
///   * [HttpHeaders]
class HttpTestHeaders implements HttpHeaders {
  factory HttpTestHeaders._(Map<String, String> headers) {
    final values = <String, List<String>>{};
    headers.forEach((String key, String value) {
      values[key] = value.split(',').map((value) => value.trim()).toList();
    });
    return HttpTestHeaders.__(values);
  }

  HttpTestHeaders.__(this._headers);

  final Map<String, List<String>> _headers;

  @override
  List<String>? operator [](String name) {
    return _headers[name];
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.putIfAbsent(name, () => <String>[]).add(value.toString());
  }

  @override
  void clear() {
    _headers.clear();
  }

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _headers.forEach(action);
  }

  @override
  void noFolding(String name) {}

  @override
  void remove(String name, Object value) {
    _headers[name]?.remove(value.toString());
  }

  @override
  void removeAll(String name) {
    _headers.remove(name);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers[name] = <String>[value.toString()];
  }

  @override
  String? value(String name) {
    final values = _headers[name];
    if (values == null) {
      return null;
    }
    return values.single;
  }

  @override
  bool chunkedTransferEncoding = false;

  @override
  int contentLength = 0;

  @override
  ContentType? contentType;

  @override
  DateTime? date;

  @override
  DateTime? expires;

  @override
  String? host;

  @override
  DateTime? ifModifiedSince;

  @override
  bool persistentConnection = false;

  @override
  int? port;
}
