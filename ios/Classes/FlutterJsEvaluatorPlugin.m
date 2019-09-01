#import "FlutterJsEvaluatorPlugin.h"
#import <flutter_js_evaluator/flutter_js_evaluator-Swift.h>

@implementation FlutterJsEvaluatorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterJsEvaluatorPlugin registerWithRegistrar:registrar];
}
@end
