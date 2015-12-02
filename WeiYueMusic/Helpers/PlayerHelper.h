//
//  PlayerHelper.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerHelper : NSObject
@property (nonatomic, strong) AVQueuePlayer *aPlayer;

+ (instancetype)sharePlayerHelper;
@end
