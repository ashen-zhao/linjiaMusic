//
//  MusicModel.h
//  ;;
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property (nonatomic, strong) NSNumber *singer_id, *song_id;
@property (nonatomic, copy) NSString *singer_name, *song_name;
@property (nonatomic, copy) NSString *album_name;//专辑名字
@property (nonatomic, strong) NSNumber *album_id;//专辑id
@property (nonatomic, assign) NSInteger pick_count;

@property (nonatomic, copy) NSString *pic_url;  //存储歌曲图片

@property (nonatomic, strong) NSMutableArray *url_list;

//排行数据中得简介
@property (nonatomic, copy) NSString *alias;

//url_list数组中是字典集合
//"url_list": [
//             {
//                 "duration": "03:23",
//                 "format": "m4a",
//                 "bitrate": 32,
//                 "type_description": "压缩品质",
//                 "url": "b.ali.hotchanson.com/8065807e782a5c4f/1437132686/m4a_32_11/fd/65/fdffb1fcc5153e64f0f1c88be9163e65.m4a?s=t",
//                 "size": "0.81M",
//                 "type": 1
//             },
//             {
//                 "duration": "03:23",
//                 "format": "mp3",
//                 "bitrate": 128,
//                 "type_description": "标准品质",
//                 "url": "nie.dfe.yymommy.com/8065807e782a5c4f/1437132686/mp3_128_11/fd/65/fdffb1fcc5153e64f0f1c88be9163e65.mp3?s=t",
//                 "size": "3.10M",
//                 "type": 2
//             },
//             {
//                 "duration": "03:23",
//                 "format": "mp3",
//                 "bitrate": 320,
//                 "type_description": "超高品质",
//                 "url": "ttp://b.ali.hotchanson.com/d1cf3f2cde236f67/1437132686/mp3_190_11/4f/4e/4f8400842de2d3a40d7c27e0b4d0f94e.mp3?s=t",
//                 "size": "7.76M", 
//                 "type": 3
//             }
//             ],
@end
