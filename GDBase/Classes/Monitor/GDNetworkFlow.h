//
//  GDNetworkFlow.h
//  Pods
//
//  Created by jelly on 2019/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDNetworkFlow : NSObject

/** 流量属性 **/
@property (nonatomic, assign) u_int32_t kWiFiSent;
@property (nonatomic, assign) u_int32_t kWiFiReceived;
@property (nonatomic, assign) u_int32_t kWWANSent;
@property (nonatomic, assign) u_int32_t kWWANReceived;


/** 开始监听**/
- (void)startMonitor:(void (^)(u_int32_t sendFlow, u_int32_t receivedFlow))block;

- (void)stopMonitor;


@end

NS_ASSUME_NONNULL_END
