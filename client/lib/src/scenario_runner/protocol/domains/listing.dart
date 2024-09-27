import 'package:built_collection/built_collection.dart';
import 'package:rxdart/rxdart.dart';
import '../connection.dart';
import '../models.dart' show ScenarioReference;

class ListingHost {
  final Channel _channel;
  final allScenarios =
      BehaviorSubject<BuiltMap<BuiltList<String>, ScenarioReference>>.seeded(
          BuiltMap());

  ListingHost(Connection connection)
      : _channel = connection.createChannel('Listing');

  Future<BuiltMap<BuiltList<String>, ScenarioReference>> list() async {
    var result = (await _channel.sendRequest<BuiltList>('list'))
        .cast<ScenarioReference>();

    //TODO(xha): should only update the names of the scenario + a flag saying that it may be dirty.
    // + remove the one not there anymore.
    var oldMap = allScenarios.value;
    var newScenarios = oldMap.rebuild((b) {
      b.clear();
      for (var newEntry in result) {
        var oldEntry = oldMap[newEntry.name];
        if (oldEntry != null) {
          b[newEntry.name] =
              oldEntry.rebuild((b) => b..description = newEntry.description);
        } else {
          b[newEntry.name] = newEntry;
        }
      }
    });
    allScenarios.add(newScenarios);
    return newScenarios;
  }

  void dispose() {
    allScenarios.close();
  }
}

class ListingClient {
  final Channel channel;
  final Iterable<ScenarioReference> Function() list;

  ListingClient(Connection connection, {required this.list})
      : channel = connection.createChannel('Listing') {
    channel.registerMethod('list', _list);
  }

  BuiltList<ScenarioReference> _list() {
    var result = BuiltList<ScenarioReference>(list());
    return result;
  }
}
