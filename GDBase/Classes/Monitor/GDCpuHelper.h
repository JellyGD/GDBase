//
//  GDCpuHelper.h
//  Pods
//
//  Created by jelly on 2019/1/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDCpuHelper : NSObject



- (void)starMonitor:(void (^)(CGFloat cpuUsage))block;


- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
