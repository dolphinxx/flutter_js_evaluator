package com.whaleread.flutter_js_evaluator_example;

import android.os.Bundle;

import com.whaleread.flutter_js_evaluator.FlutterJsEvaluatorPlugin;

import io.flutter.app.FlutterActivity;

public class EmbeddingV1Activity extends FlutterActivity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    FlutterJsEvaluatorPlugin.registerWith(registrarFor("com.whaleread.flutter_js_evaluator.FlutterJsEvaluatorPlugin"));
  }
}
