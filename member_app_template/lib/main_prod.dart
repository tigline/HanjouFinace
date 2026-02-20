import 'app/bootstrap.dart';
import 'app/config/app_flavor.dart';

Future<void> main() async {
  await bootstrap(flavor: AppFlavor.prod);
}
