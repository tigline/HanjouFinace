import 'package:core_storage/core_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('writes, reads, removes and clears values', () async {
    final storage = InMemoryKeyValueStorage();

    await storage.write('k1', 'v1');
    await storage.write('k2', 'v2');

    expect(await storage.read('k1'), 'v1');
    expect(await storage.read('k2'), 'v2');

    await storage.remove('k1');
    expect(await storage.read('k1'), isNull);
    expect(await storage.read('k2'), 'v2');

    await storage.clear();
    expect(await storage.read('k2'), isNull);
  });
}
