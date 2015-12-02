//
//  MusicModel.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"songId"]) {
        self.song_id = value;
    }
    if ([key isEqualToString:@"singerName"]) {
        self.singer_name = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.song_name = value;
    }
    
    if ([key isEqualToString:@"albumName"]) {
        self.album_name = value;
    }
    if ([key isEqualToString:@"urlList"]) {
        self.url_list = value;
    }
    
    if ([key isEqualToString:@"favorites"]) {
        self.pick_count = [value integerValue];
    }
}
@end
