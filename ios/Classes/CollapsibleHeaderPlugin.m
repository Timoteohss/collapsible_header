#import "CollapsibleHeaderPlugin.h"
#import <collapsible_header/collapsible_header-Swift.h>

@implementation CollapsibleHeaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCollapsibleHeaderPlugin registerWithRegistrar:registrar];
}
@end
