//
//  NSTimer+Control.h
//  iCoderZhiShi
//
//  Created by lanouhn on 15/6/3.
//  Copyright (c) 2015年 赵阿申. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Control)
- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
