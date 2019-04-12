#import "FlutterCtrlpanelCorePlugin.h"
#import <flutter_ctrlpanel_core/flutter_ctrlpanel_core-Swift.h>

@implementation FlutterCtrlpanelCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCtrlpanelCorePlugin registerWithRegistrar:registrar];
}
@end
