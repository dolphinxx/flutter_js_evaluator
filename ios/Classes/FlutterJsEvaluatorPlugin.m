#import "FlutterJsEvaluatorPlugin.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation FlutterJsEvaluatorPlugin
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
        JSValue *value = [context evaluateScript:source];
        if([call.arguments objectForKey:@"property"]) {
            value = [context objectForKeyedSubscript:call.arguments[@"property"]];
        }
        result([FlutterJsEvaluatorPlugin toJSON:value]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (NSString*)toJSON:(JSValue*)value {
    if([value isNull] || [value isUndefined]) {
        return @"null";
    }
    if([value isBoolean]) {
        return [value toBool] ? @"true" : @"false";
    }
    if([value isString]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:@[[value toString]] options:0 error:&error];
        if (data != nil) {
            NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            return [s substringWithRange:NSMakeRange(1, [s length] - 2)];
        }
        NSLog(@"JSON encode string failed with error: %@", error);
        return nil;
    }
    if([value isNumber]) {
        return [[value toNumber] description];
    }
    NSError *error = nil;
    if (@available(iOS 9.0, *)) {
        if([value isDate]) {
            return [[value toNumber] description];
        }
        if([value isArray]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:[value toArray] options:0 error:&error];
            if (data != nil) {
                return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            NSLog(@"JSON encode array failed with error: %@", error);
            return nil;
        }
    }
    if([value isObject]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:[value toObject] options:0 error:&error];
        if (data != nil) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        NSLog(@"JSON encode object failed with error: %@", error);
        return nil;
    }
    NSLog(@"Unrecognized JSValue type: %@", value);
    return nil;
}

@end
