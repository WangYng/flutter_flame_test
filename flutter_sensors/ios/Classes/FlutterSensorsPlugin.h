//
//  FlutterSensorsPlugin.h
//  Pods
//
//  Created by 汪洋 on 2024/8/26.
//

#import <Flutter/Flutter.h>
#import "FlutterSensorsApi.h"

@interface FlutterSensorsPlugin : NSObject<FlutterSensorsApiDelegate>

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end
