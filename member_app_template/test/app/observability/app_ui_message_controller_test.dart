import 'package:flutter_test/flutter_test.dart';
import 'package:member_app_template/app/observability/app_observability_providers.dart';

void main() {
  group('AppUiMessageController', () {
    test('publishes and clears message by id', () {
      final controller = AppUiMessageController();

      controller.showError('network error');
      final first = controller.state;

      expect(first, isNotNull);
      expect(first!.message, 'network error');

      controller.clearIfMatches(first.id);
      expect(controller.state, isNull);
    });
  });
}
