//
//  SongTypeModel.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongTypeModel : NSObject
@property (nonatomic, strong) NSNumber *songlist_id;
@property (nonatomic, copy) NSString *songlist_name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *parentname; //分区名
@property (nonatomic, copy) NSString *large_pic_url, *small_pic_url, *pic_url_240_200;

@end
