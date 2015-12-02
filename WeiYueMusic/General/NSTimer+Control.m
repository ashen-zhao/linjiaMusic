//
//  NSTimer+Control.m
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import "NSTimer+Control.h"

@implementation NSTimer (Control)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
