//
//  bottomPlayView.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerHelper.h"

@class MusicModel;
@interface BottomPlayView : UIView
@property (nonatomic, strong) UIImageView *songImage;
@property (nonatomic, strong) UILabel *lblSongName;
@property (nonatomic, strong) UILabel *lblSinger;
@property (nonatomic, strong) UIImageView *lineImage;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr; //存放当前播放的数据源
@property (nonatomic, strong) NSMutableArray *searchDataSourceArr; //存放搜索出来的新的数据源
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy)   NSString *pic_url;
@property (nonatomic, retain) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSTimer *playerTimer;

@property (nonatomic, strong) AVPlayerItem *currentItem;  //当前播放的Item, 用来与播放界面之间的播放信息通讯



@property (nonatomic, copy) void ((^TapPlayView)(NSMutableArray *dataArr, NSInteger curentIndex, NSString *pic_Url, AVPlayerItem *currentItem)); //传送到播放页面的数据

@property (nonatomic, copy) void ((^ASTimer)(AVPlayerItem *timer)); //处理播放界面的时间显示

@property (nonatomic, copy) void ((^NextSong)());


//单例全局播放小试图
+ (BottomPlayView *)shareBottomPlayView;

- (void)setupPlayerWithModel:(MusicModel *)model;

@end
