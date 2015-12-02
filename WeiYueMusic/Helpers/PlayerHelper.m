//
//  PlayerHelper.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "PlayerHelper.h"

@implementation PlayerHelper
+ (instancetype)sharePlayerHelper {
    static PlayerHelper *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[PlayerHelper alloc] init];
    });
    return player;
}
- (instancetype)init {
    if (self = [super init]) {
        self.aPlayer = [[AVQueuePlayer alloc] init];
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
    return self;
}
@end
