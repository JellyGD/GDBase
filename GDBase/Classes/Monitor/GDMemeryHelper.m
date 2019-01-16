//
//  GDMemeryHelper.m
//  Pods
//
//  Created by jelly on 2019/1/16.
//

#import "GDMemeryHelper.h"
#import <mach/mach.h>

@interface GDMemeryHelper ()



@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *records;

@property (nonatomic, copy) void (^memeryBlock)(CGFloat memeryUsage);  //每秒获取

@end

@implementation GDMemeryHelper


- (void)dealloc{
    [self stopMonitor];
    self.memeryBlock = nil;
}


- (void)startMonitor:(void (^)(CGFloat))block{
    if (!self.records){
        self.records = [NSMutableArray new];
    }
    
    self.memeryBlock = block;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getMemeryUsage) userInfo:nil repeats:YES];
}

- (void)stopMonitor{
    [self.timer invalidate];
    self.timer = nil;
}

/** 是否激活中 **/
- (BOOL)isActived{
    return self.timer != nil;
    }

/**  **/
- (void)getMemeryUsage{
    CGFloat u = [GDMemeryHelper getUsedMemory];
    [self.records addObject:@{@"date":[NSDate date], @"value":@(u)}];
    
    //记录1小时
    if (self.records.count > 60*60){
        [self.records removeObjectAtIndex:0];
    }
    
    if (self.memeryBlock){
        self.memeryBlock(u);
    }
}

/** 获取 内存 记录 **/
- (NSArray *)getRecords{
    return self.records;
}

/** 获取当前应用的内存 */
+ (CGFloat)getUsedMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    if(kernReturn != KERN_SUCCESS){
        return 0;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
@end
