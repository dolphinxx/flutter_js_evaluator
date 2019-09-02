import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterJsEvaluator {
  static const MethodChannel _channel =
      const MethodChannel('flutter_js_evaluator');

  /// property: whether return variable with name `property`
  static Future<dynamic> evaluate(String source, {String property}) async {
    Map<String, dynamic> args = Map();
    args['source'] = source;
    if(property?.isNotEmpty == true) {
      args['property'] = property;
    }
    final String result = await _channel.invokeMethod('evaluate', args);
    return jsonDecode(result);
  }
}
