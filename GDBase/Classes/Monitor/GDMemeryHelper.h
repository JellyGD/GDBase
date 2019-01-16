//
//  GDMemeryHelper.h
//  Pods
//
//  Created by jelly on 2019/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDMemeryHelper : NSObject


/** 获取当前应用的内存 */
+ (CGFloat)getUsedMemory;

/** 获取 内存 记录 **/
- (NSArray *)getRecords;

/** 是否激活中 **/
- (BOOL)isActived;

/** 开始监听**/
- (void)startMonitor:(void (^)(CGFloat memUsage))block;

- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
