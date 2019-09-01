import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_js_evaluator/flutter_js_evaluator.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_js_evaluator');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('evaluate', () async {
    expect(await FlutterJsEvaluator.evaluate('var a = 42;return a;'), 42);
  });
}
