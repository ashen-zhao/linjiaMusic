//
//  MusicHotModel.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicHotModel.h"

@implementation MusicHotModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"picUrl"]) {
        self.pic_url = value;
    }
    
    if ([key isEqualToString:@"listenCount"]) {
        self.listen_count = value;
    }
}
@end
