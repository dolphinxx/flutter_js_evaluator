import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterJsEvaluator {
  static final MethodChannel _channel =
      const MethodChannel('flutter_js_evaluator');

  /// preload js libraries
  static Future<bool> preload(String? source) async {
    if(source?.isNotEmpty != true) {
      return false;
    }
    return await _channel.invokeMethod('preload', source) as bool;
  }

  /// property: whether return variable with name `property`
  static Future<dynamic> evaluate(String source, {String? property}) async {
    Map<String, dynamic> args = {};
    args['source'] = source;
    if(property?.isNotEmpty == true) {
      args['property'] = property;
    }
    final String? result = await _channel.invokeMethod('evaluate', args) as String?;
    if(result == null) {
      return null;
    }
    return jsonDecode(result);
  }
}
