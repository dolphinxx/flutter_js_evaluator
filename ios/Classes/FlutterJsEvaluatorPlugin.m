#import "FlutterJsEvaluatorPlugin.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation FlutterJsEvaluatorPlugin

NSString* lib = @"";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_js_evaluator"
                                     binaryMessenger:[registrar messenger]];
    FlutterJsEvaluatorPlugin* instance = [[FlutterJsEvaluatorPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"evaluate" isEqualToString:call.method]) {
        NSString *source = call.arguments[@"source"];
        JSContext *context = [[JSContext alloc] init];
        if([call.arguments objectForKey:@"property"]) {
            source = [NSString stringWithFormat: @"%@;%@;var __r__=%@;__r__===undefined?'undefined':JSON.stringify(__r__)", lib, source, call.arguments[@"property"]];
        } else {
            source = [NSString stringWithFormat:@"%@;var __r__=eval(%@);__r__===undefined?'undefined':JSON.stringify(__r__)",lib,[FlutterJsEvaluatorPlugin stringEscapeJavascript:source]];
//            NSLog(@"source:\n%@", source);
        }
        JSValue *value = [context evaluateScript:source];
        NSString *str = [value toString];
        if([str  isEqual: @"undefined"]) {
            str = @"null";
        }
        result(str);
    } else if([@"preload" isEqualToString:call.method]) {
        lib = [lib stringByAppendingString:call.arguments];
        result(@YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (NSString *)stringEscapeJavascript:(NSString *)raw {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[raw] options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [string substringWithRange:NSMakeRange(1, [string length] - 2)];
}

@end
