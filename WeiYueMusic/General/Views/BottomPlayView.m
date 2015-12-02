//
//  bottomPlayView.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "BottomPlayView.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
#import "AppDelegate.h"
#import "PlayRecordEntity.h"
#import "RecordDBHelper.h"

@interface BottomPlayView()

@end

@implementation BottomPlayView


+ (BottomPlayView *)shareBottomPlayView {
    static BottomPlayView *bpv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bpv = [[BottomPlayView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    });
    return bpv;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        [_contentView addSubview:self.songImage];
        [_contentView addSubview:self.lblSongName];
        [_contentView addSubview:self.lblSinger];
        [_contentView addSubview:self.lineImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

- (UIImageView *)songImage {
    if (!_songImage) {
        self.songImage = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 50, 48)];
        _songImage.layer.cornerRadius = 3;
        _songImage.layer.masksToBounds = YES;
        _songImage.image = [UIImage imageNamed:@"effect_env_none.jpg"];
    }
    return _songImage;
}

- (UILabel *)lblSinger {
    if (!_lblSinger) {
        self.lblSinger = [[UILabel alloc] initWithFrame:CGRectMake(61, 2 + 20 + 2   , 120, 15)];
        _lblSinger.text = @"微乐提醒";
        _lblSinger.font = [UIFont systemFontOfSize:14];
        _lblSinger.textColor = [UIColor lightGrayColor];
    }
    return _lblSinger;
}

- (UILabel *)lblSongName {
    if (!_lblSongName) {
        self.lblSongName = [[UILabel alloc] initWithFrame:CGRectMake(10 + 50 + 1, 2, 200, 20)];
        _lblSongName.text = @"没有选择播放的歌曲";
        _lblSongName.font = [UIFont systemFontOfSize:16];
        _lblSongName.textColor = [UIColor colorWithRed:41 / 255.0 green:36 / 255.0  blue:33 / 255.0  alpha:1.0];
    }
    return _lblSongName;
}

- (UIImageView *)lineImage {
    if (!_lineImage) {
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 5, 40, 40)];
        _lineImage.layer.cornerRadius = 20;
        _lineImage.layer.masksToBounds = YES;
        _lineImage.image = [UIImage imageNamed:@"playLine.png"];
    }
    return _lineImage;
}

#pragma mark - Action
//轻拍手势
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (self.TapPlayView) {
        self.TapPlayView(_dataSourceArr, _currentIndex, _pic_url, _currentItem);
    }
}

- (void)setupPlayerWithModel:(MusicModel *)model  {
    
    _lblSongName.text = model.song_name;
    _lblSinger.text = model.singer_name;
    if ([_pic_url isEqualToString:@""]) {
        _pic_url = model.pic_url;
    }
    [_songImage sd_setImageWithURL:[NSURL URLWithString:_pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    
    //播放器
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[model.url_list firstObject][@"url"]]];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    PlayerHelper *player = [PlayerHelper sharePlayerHelper];
    [player.aPlayer replaceCurrentItemWithPlayerItem:_playerItem];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];
    [player.aPlayer play];
    _lineImage.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"line1"],[UIImage imageNamed:@"line2"],[UIImage imageNamed:@"line3"],[UIImage imageNamed:@"line4"], nil];
    _lineImage.animationDuration = 1.0;
    if (self.playerTimer) {
        [self.playerTimer invalidate];
    }
    //添加计时器
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleActionTime:) userInfo:_playerItem repeats:YES];
    
    if (model != nil) {
        PlayRecordEntity *record = [RecordDBHelper getRecordEntity];
        NSInteger autoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"autoID"];
        autoId++;
        record.autoID = (int)autoId;
        record.songID = [NSString stringWithFormat:@"%@", model.song_id];
        record.songFrom = @"playRecord";
        record.songImage = _pic_url;
        record.songName = model.song_name;
        record.songSinger = model.singer_name;
        record.songUrl = [model.url_list firstObject][@"url"];
        record.songPlayCount = [NSString stringWithFormat:@"%ld",(long)model.pick_count];
        [RecordDBHelper insertWithRecordEntity:record];
        [[NSUserDefaults standardUserDefaults] setInteger:autoId forKey:@"autoID"];
    }
}

#pragma mark 计时器
- (void)handleActionTime:(NSTimer *)timer {
    AVPlayerItem *newItem = (AVPlayerItem *)timer.userInfo;
    if ([newItem status] == AVPlayerStatusReadyToPlay) {
        [_lineImage startAnimating];
        //当播放时，存储当前播放的Item， 用来与播放界面之间的信息通讯
        _currentItem = newItem;
        if (self.ASTimer) {
            self.ASTimer(newItem);
        }
    }
}

//歌曲播放完后处理事件
- (void)playerItemAction:(AVPlayerItem *)item {
    [self.playerTimer invalidate];
    if (self.NextSong) {
        self.NextSong();
    } else {
        //给系统一个延迟，准备播放下一首(如果不延迟，将不能自己播放下一首ps:或许player还没有准备好播放)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self nextSong];
        });
        
    }
}
//获取下一首歌曲
- (void)nextSong {
    [BottomPlayView shareBottomPlayView].playerItem = nil;
    if (++_currentIndex >= _dataSourceArr.count) {
        _currentIndex = 0;
        [self setupPlayerWithModel:[_dataSourceArr firstObject]];
    } else {
        [self setupPlayerWithModel:_dataSourceArr[_currentIndex]];
    }
}

@end
