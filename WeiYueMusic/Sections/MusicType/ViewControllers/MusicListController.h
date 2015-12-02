//
//  MusicListController.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListController : UIViewController
@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, copy)   NSString *navTitile;
@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *from; //标识从哪个界面push来的
@property (nonatomic, copy) NSString *pic_url;//用来接收从排行传过来的图片

@end
