//
//  GDCpuHelper.m
//  Pods
//
//  Created by jelly on 2019/1/15.
//

#import "GDCpuHelper.h"
#import <mach/mach.h>
#import <sys/time.h>


@interface GDCpuHelper ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) void (^cpuBlock)(CGFloat cpuUsage);  //每秒获取

@end

@implementation GDCpuHelper

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.cpuBlock = nil;
}

- (void)starMonitor:(void (^)(CGFloat cpuUsage))block{
    [self stopMonitor];
    self.cpuBlock = block;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCpuUsage) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)stopMonitor{
    self.cpuBlock = nil;
    [self.timer invalidate];
    self.timer = nil;
}



- (void)getCpuUsage{
    float cpuUsage = [GDCpuHelper cpuUsage];
    struct tm* timeNow = [GDCpuHelper getCurTime];
    NSString *monitorLog = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d.%ld | cpu 使用率:%.2f ",
                            timeNow->tm_year,
                            timeNow->tm_mon,
                            timeNow->tm_mday,
                            timeNow->tm_hour,
                            timeNow->tm_min,
                            timeNow->tm_sec,
                            timeNow->tm_gmtoff,
                            cpuUsage];
    NSLog(@"%@",monitorLog);
    if (self.cpuBlock) {
        self.cpuBlock(cpuUsage);
    }
}

+ (struct tm*)getCurTime{
    //时间格式
    struct timeval ticks;
    gettimeofday(&ticks, nil);
    time_t now;
    struct tm* timeNow;
    time(&now);
    timeNow = localtime(&now);
    timeNow->tm_gmtoff = ticks.tv_usec/1000;  //毫秒
    
    timeNow->tm_year += 1900;    //tm中的tm_year是从1900至今数
    timeNow->tm_mon  += 1;       //tm_mon范围是0-11
    
    return timeNow;
}

+ (float)cpuUsage{
    float cpu = cpu_usage();
    return cpu;
}

/**
 获取CPU的使用情况
 注：目前获取CPU的算法是根据网上搜罗的代码的。
 @return 返回CPU的使用率
 */
float cpu_usage(){
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}


@end
