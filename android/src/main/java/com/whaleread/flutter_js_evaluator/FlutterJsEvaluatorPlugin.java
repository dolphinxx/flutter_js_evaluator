package com.whaleread.flutter_js_evaluator;

import org.liquidplayer.javascript.JSContext;
import org.liquidplayer.javascript.JSFunction;
import org.liquidplayer.javascript.JSValue;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterJsEvaluatorPlugin implements MethodCallHandler {

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_js_evaluator");
        channel.setMethodCallHandler(new FlutterJsEvaluatorPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("evaluate")) {
            String source = call.argument("source");
            String property = call.hasArgument("property") ? call.<String>argument("property") : null;
            JSContext context = new JSContext();
            JSValue value = context.evaluateScript(source);
            if (property != null) {
                result.success(context.property(property).toJSON());
            } else {
                result.success(value.toJSON());
            }
        } else {
            result.notImplemented();
        }
    }
}
