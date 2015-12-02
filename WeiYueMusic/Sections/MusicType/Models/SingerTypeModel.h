//
//  SingerTypeModel.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingerTypeModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *title, *details;
@property (nonatomic, copy) NSString *pic_url, *time;
@property (nonatomic, strong) NSNumber *count;
@end
