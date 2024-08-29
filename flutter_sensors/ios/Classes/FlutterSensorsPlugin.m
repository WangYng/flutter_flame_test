//
//  FlutterSensorsPlugin.m
//  Pods
//
//  Created by 汪洋 on 2024/8/26.
//

#import "FlutterSensorsPlugin.h"
#import "FlutterSensorsEventSink.h"
#import <CoreMotion/CoreMotion.h>

const double GRAVITY = 9.81;

@interface FlutterSensorsPlugin()

@property (nonatomic, strong) FlutterSensorsEventSink *accelerometerEventStream;

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation FlutterSensorsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterSensorsPlugin* instance = [[FlutterSensorsPlugin alloc] init];
    [FlutterSensorsApi setup:registrar api:instance];
}

- (void)register {
    if (self.motionManager == nil) {
        _motionManager = [CMMotionManager new];
        _motionManager.accelerometerUpdateInterval = 0.2;
    }
    
    __weak typeof(self) ws = self;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (error != nil) {
            return;
        }
        
        if (ws.accelerometerEventStream != nil && ws.accelerometerEventStream.event != nil) {
            NSMutableDictionary<NSString *, NSObject *> *event = [NSMutableDictionary new];
            event[@"x"] = @(-accelerometerData.acceleration.x * GRAVITY);
            event[@"y"] = @(-accelerometerData.acceleration.y * GRAVITY);
            event[@"z"] = @(-accelerometerData.acceleration.z * GRAVITY);
            dispatch_async(dispatch_get_main_queue(), ^{
                ws.accelerometerEventStream.event(event);
            });
        }
    }];
}

- (void)unregister {
    if (self.motionManager != nil) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager = nil;
    }
}

@end
