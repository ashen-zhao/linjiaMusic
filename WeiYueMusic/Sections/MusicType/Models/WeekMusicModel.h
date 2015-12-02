//
//  WeekMusicModel.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekMusicModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title,*details, *pic_url;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSMutableArray *songlist;
//songlist数组中是字典集合
//{
//    "singerName": "筷子兄弟",
//    "songName": "小苹果"
//},
@end
