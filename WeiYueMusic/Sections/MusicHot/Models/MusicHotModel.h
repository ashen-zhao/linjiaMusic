//
//  MusicHotModel.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicHotModel : NSObject
@property (nonatomic, copy) NSString *name, *desc;//分区名字
@property (nonatomic, strong) NSNumber *style; //暂时不知
@property (nonatomic, strong) NSNumber *_id, *order; //id和数量
@property (nonatomic, strong) NSMutableArray *data;

//data中
//_id, desc, name, order, pic_url, tag, action:{type, value:"http://.php"}
//在热门歌单中 data中
//listen_count, author, id

@property (nonatomic, strong) NSDictionary *action;
@property (nonatomic, strong) NSString *pic_url, *listen_count, *author, *ID;

@end
