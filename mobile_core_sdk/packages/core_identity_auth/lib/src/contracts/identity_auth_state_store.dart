import 'package:core_foundation/core_foundation.dart';

abstract class IdentityAuthStateStore {
  Future<IdentityAuthSnapshot> readSnapshot();

  Future<void> writeSnapshot(IdentityAuthSnapshot snapshot);
}
