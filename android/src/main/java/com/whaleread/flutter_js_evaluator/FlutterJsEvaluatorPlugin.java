package com.whaleread.flutter_js_evaluator;

import android.util.Log;

import org.json.JSONObject;

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
            if(property != null) {
                source += ";var __r__=" + property + ";__r__===undefined?'undefined':JSON.stringify(__r__)";
            } else {
                source = "var __r__=eval(" + JSONObject.quote(source) + ");__r__ === undefined ? 'undefined':JSON.stringify(__r__)";
            }
//            Log.d("----", source);
//            String str = evaluateThroughJ2V8(source);
            String str = evaluateThroughQuickJs(source);
//            String str = evaluateThroughLiquidCore(source);
            result.success(str != null && str.equals("undefined") ? "null" : str);
//            result.success(evaluateThroughRhino(source, property));
        } else {
            result.notImplemented();
        }
    }

//    private static String evaluateThroughLiquidCore(String source) {
//        org.liquidplayer.javascript.JSContext context = new org.liquidplayer.javascript.JSContext();
//        org.liquidplayer.javascript.JSValue value = context.evaluateScript(source);
//        return value.toString();
//    }

//    private static String evaluateThroughDuktape(String source, String property) {
//        com.squareup.duktape.Duktape context = com.squareup.duktape.Duktape.create();
//        Object value = context.evaluate(source);
//        if(property != null) {
//            value = context.get(property, Object.class);
//        }
//        return JSONUtil.wrap(value).toString();
//    }

//    private static String evaluateThroughJ2V8(String source) {
//        com.eclipsesource.v8.V8 v8 = com.eclipsesource.v8.V8.createV8Runtime();
//        String result;
//        try {
//            result = v8.executeStringScript(source);
//        } finally {
//            try {
//                v8.release(true);
//                v8.close();
//            } catch (Exception e) {
//                Log.e("Flutter_JS_Evaluator", "failed to release V8", e);
//            }
//        }
//        return result;
//    }

    private static com.hippo.quickjs.android.QuickJS quickJS;
    private static String evaluateThroughQuickJs(String source) {
        if(quickJS == null) {
            quickJS = new com.hippo.quickjs.android.QuickJS.Builder().build();
        }
        com.hippo.quickjs.android.JSRuntime runtime = quickJS.createJSRuntime();
        com.hippo.quickjs.android.JSContext context = runtime.createJSContext();
        String result;
        try {
            result = context.evaluate(source, "flutter_js_evaluator.js", String.class);
        } finally {
            try {
                context.close();
                runtime.close();
            } catch (Exception e) {
                Log.e("Flutter_JS_Evaluator", "failed to release QuickJS", e);
            }
        }

        return result;
    }

//    private static String evaluateThroughJsEvaluatorForAndroid(String source, String property) {
//        com.evgenii.jsevaluator.JsEvaluator jsEvaluator = new com.evgenii.jsevaluator.JsEvaluator(registrar.activity());
//        jsEvaluator.evaluate(source, new com.evgenii.jsevaluator.interfaces.JsCallback() {
//            @Override
//            public void onResult(String s) {
//
//            }
//
//            @Override
//            public void onError(String s) {
//
//            }
//        });
//    }

    // OutOfMemoryError when evaluating large piece of codes
//    private static String evaluateThroughRhino(String source, String property) {
//        org.mozilla.javascript.Context context = org.mozilla.javascript.Context.enter();
//        context.setOptimizationLevel(-1);
//        context.getWrapFactory().setJavaPrimitiveWrap(false);
//        org.mozilla.javascript.Scriptable scope = context.initStandardObjects();
//        Object value = context.evaluateString(scope, source, "JavaScript", 1, null);
//        if(property != null) {
//            value = scope.get(property, scope);
//            if(value == org.mozilla.javascript.Scriptable.NOT_FOUND) {
//                return null;
//            }
//        }
//        if(value == null) {
//            return null;
//        }
//        return (String)org.mozilla.javascript.NativeJSON.stringify(context, scope, value, null, null);
//    }
}
