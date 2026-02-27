import 'app/bootstrap.dart';
import 'app/config/app_flavor.dart';

Future<void> main() async {
  const appFlavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'dev');
  await bootstrap(flavor: parseAppFlavor(appFlavor));
}
