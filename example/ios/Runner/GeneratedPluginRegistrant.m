//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<battery_info/BatteryInfoPlugin.h>)
#import <battery_info/BatteryInfoPlugin.h>
#else
@import battery_info;
#endif

#if __has_include(<carrier_info/CarrierInfoPlugin.h>)
#import <carrier_info/CarrierInfoPlugin.h>
#else
@import carrier_info;
#endif

#if __has_include(<device_info_plus/FPPDeviceInfoPlusPlugin.h>)
#import <device_info_plus/FPPDeviceInfoPlusPlugin.h>
#else
@import device_info_plus;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [BatteryInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"BatteryInfoPlugin"]];
  [CarrierInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"CarrierInfoPlugin"]];
  [FPPDeviceInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPDeviceInfoPlusPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
}

@end
