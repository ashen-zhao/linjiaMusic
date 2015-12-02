//
//  PlayViewController.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayViewController : UIViewController
@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy)   NSString *pic_url;
@property (nonatomic, strong) AVPlayerItem *currentItem;
@end
