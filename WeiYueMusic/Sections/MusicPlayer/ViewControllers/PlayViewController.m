//
//  PlayViewController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "PlayViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "PlayerHelper.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "BottomPlayView.h"
#import "NSTimer+Control.h"
#import "RecordDBHelper.h"
#import "PlayRecordEntity.h"


@interface PlayViewController () {
    BOOL isRandom;
}
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UILabel *lblSinger;
@property (weak, nonatomic) IBOutlet UIImageView *imageSong;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDuratiionTime;
@property (weak, nonatomic) IBOutlet UISlider *sliderBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblSong_Height;

@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayType;


@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

@property (nonatomic, strong) PlayerHelper *player;

@end

@implementation PlayViewController

#pragma mark 系统类

//单独定制白色电池条
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setUpBottomView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationItem.title = @"播放界面";
    [self setupSliderStyle];
    
    //判断bottom传来的Item是否是正在播放的
    if (_currentItem) {
        self.lblCurrentTime.text = [self timeformatFromSeconds:CMTimeGetSeconds(_currentItem.currentTime) - 1];
        self.lblDuratiionTime.text = [self timeformatFromSeconds:CMTimeGetSeconds(_currentItem.duration)];
        self.sliderBar.maximumValue = CMTimeGetSeconds(_currentItem.duration);
        self.sliderBar.value = CMTimeGetSeconds(_currentItem.currentTime);
    }
    isRandom = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRandom"];
    if (isRandom) {
        [self.btnPlayType setImage:[UIImage imageNamed:@"repeat4.png"] forState:UIControlStateNormal];
    }
    [self setUpPlayDataWithMusicModel: _dataArr[_currentIndex]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

//喜欢事件
- (IBAction)btnFavoriteAction:(id)sender {    
    MusicModel *model = _dataArr[_currentIndex];
    if (model != nil) {
        NSInteger autoId = [[NSUserDefaults standardUserDefaults] integerForKey:@"autoID"];
        autoId++;
        PlayRecordEntity *record = [RecordDBHelper getRecordEntity];
        record.autoID = (int)autoId;
        record.songID = [NSString stringWithFormat:@"%@", model.song_id];
        record.songFrom = @"favorite";
        record.songImage = _pic_url;
        record.songName = model.song_name;
        record.songSinger = model.singer_name;
        record.songUrl = [model.url_list firstObject][@"url"];
        record.songPlayCount = [NSString stringWithFormat:@"%ld", (long)model.pick_count];
        [RecordDBHelper insertWithRecordEntity:record];
        
        [[NSUserDefaults standardUserDefaults] setInteger:autoId forKey:@"autoID"];
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"收藏成功";
        [mb hide:YES afterDelay:0.5];
    }
}

//点击返回区域
- (IBAction)tapBack:(UITapGestureRecognizer *)sender {
    [self.navigation popViewControllerAnimated:YES];
}
//上一首
- (IBAction)btnPer:(UIButton *)sender {
    //如果当前播放不存在，则返回
    if (!_currentItem) {
        return;
    }
    if (_dataArr.count == 1) {
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"-.-只有一首歌";
        [mb hide:YES afterDelay:0.5];
        return;
    }
    //将上一个Item置为nil， 为下一个播放做准备
    [BottomPlayView shareBottomPlayView].playerItem = nil;
    if (--_currentIndex >= 0) {
        [self setUpPlayDataWithMusicModel:_dataArr[_currentIndex]];
    } else {
        _currentIndex = _dataArr.count - 1;
        [self setUpPlayDataWithMusicModel:_dataArr[_dataArr.count - 1]];
    }
    [self setUpBottomView];
}
//播放或暂停
- (IBAction)btnPlay:(id)sender {
    //如果当前播放不存在，则返回
    if (!_currentItem) {
        return;
    }
    PlayerHelper *player = [PlayerHelper sharePlayerHelper];
    BOOL isPlaying = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
    if (isPlaying) {
        [[BottomPlayView shareBottomPlayView].lineImage stopAnimating];
        [player.aPlayer pause];
        [[BottomPlayView shareBottomPlayView].playerTimer pauseTimer];
        [_btnPlay setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [player.aPlayer play];
        [[BottomPlayView shareBottomPlayView].playerTimer resumeTimer];
         [_btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    [[NSUserDefaults standardUserDefaults] setBool:!isPlaying forKey:@"isPlaying"];
}
//下一首action
- (IBAction)btnNext:(id)sender {
    //如果当前播放不存在，则返回
    if (!_currentItem) {
        return;
    }
    if (_dataArr.count == 1) {
        MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mb.mode = MBProgressHUDModeText;
        mb.labelText = @"-.-只有一首歌";
        [mb hide:YES afterDelay:0.5];
        return;
    }
    //判断是不是随机模式
    if (isRandom) {
        [self randomPlaySong];
    } else {
        [self nextSong];
    }
}
//获取下一首歌曲
- (void)nextSong {
    //将上一个Item置为nil， 为下一个播放做准备
    [BottomPlayView shareBottomPlayView].playerItem = nil;
    if (++_currentIndex >= _dataArr.count) {
        _currentIndex = 0;
        [self setUpPlayDataWithMusicModel:[_dataArr firstObject]];
    } else {
        [self setUpPlayDataWithMusicModel:_dataArr[_currentIndex]];
    }
    [self setUpBottomView];
}
//改变播放模式
- (IBAction)btnRandomAction:(id)sender {
    MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mb.mode = MBProgressHUDModeText;
  
    if (!isRandom) {
        [sender setImage:[UIImage imageNamed:@"repeat4.png"] forState:UIControlStateNormal];
        isRandom = YES;
        mb.labelText = @"随机模式";
    } else {
        [sender setImage:[UIImage imageNamed:@"repeat1.png"] forState:UIControlStateNormal];
        isRandom = NO;
        mb.labelText = @"循环模式";
    }
    [[NSUserDefaults standardUserDefaults] setBool:isRandom forKey:@"isRandom"];
    [mb hide:YES afterDelay:0.5];
    
}


#pragma mark UISlider事件
//值改变,拖动的过程中
- (void)sliderValueChanged:(UISlider *)slider {
    //如果当前播放不存在，则返回
    if (!_currentItem) {
        return;
    }
    self.lblCurrentTime.text = [self timeformatFromSeconds:slider.value];
    [[BottomPlayView shareBottomPlayView].playerTimer pauseTimer];
}
//拖动结束
- (void)sliderDragDone:(UISlider *)slider {
    //如果当前播放不存在，则返回
    if (!_currentItem) {
        _sliderBar.value = 0;
        return;
    }
    [[BottomPlayView shareBottomPlayView].playerTimer resumeTimer];
     _sliderBar.value = slider.value;
    //秒转成CMTime
    CMTime dragedCMTime = CMTimeMake(slider.value, 1);
    [[PlayerHelper sharePlayerHelper].aPlayer pause];
    [[PlayerHelper sharePlayerHelper].aPlayer seekToTime:dragedCMTime completionHandler:^(BOOL finished) {
        [[PlayerHelper sharePlayerHelper].aPlayer play];
    }];
}

#pragma mark Method

//随机播放一首歌
- (void)randomPlaySong {
    NSInteger index = arc4random() % _dataArr.count;
    //将当期页设置为随机的数
    _currentIndex = index;
     [BottomPlayView shareBottomPlayView].playerItem = nil;
    [self setUpPlayDataWithMusicModel:_dataArr[index]];
    [self setUpBottomView];
}

- (void)setupSliderStyle {
    //左右轨的图片
    UIImage *left= [UIImage imageNamed:@"1.png"];
    UIImage *right = [UIImage imageNamed:@"2.png"];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"knob.png"];
    
    [_sliderBar setMinimumTrackImage:left forState:UIControlStateNormal];
    [_sliderBar setMaximumTrackImage:right forState:UIControlStateNormal];
    
    [_sliderBar setThumbImage:thumbImage forState:UIControlStateNormal];
    [_sliderBar setThumbImage:thumbImage forState:UIControlStateHighlighted];
    _sliderBar.minimumValue = 0.0;
    
    //值改变
    [_sliderBar addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    //拖动后
    [_sliderBar addTarget:self action:@selector(sliderDragDone:) forControlEvents:UIControlEventTouchUpInside];
}

//重新给bottomView赋值
- (void)setUpBottomView {
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    MusicModel *model = _dataArr[_currentIndex];
    bpv.dataSourceArr = _dataArr;
    bpv.currentIndex = _currentIndex;
    bpv.lblSinger.text = model.singer_name == nil ? @"微乐提醒" : model.singer_name;
    bpv.lblSongName.text = model.song_name == nil ? @"没有选择播放的歌曲" : model.song_name;
    bpv.currentItem = _currentItem;
    //由于接口数据问题，只能传送用户图片，找不到歌手图片
    bpv.pic_url = self.pic_url;
    [bpv.songImage sd_setImageWithURL:[NSURL URLWithString:self.pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    
}

#pragma mark 设置数据
- (void)setUpPlayDataWithMusicModel:(MusicModel *)model {

    //创建模糊层
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [_blurEffectView removeFromSuperview];//移除上次模糊层
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _blurEffectView.frame = self.view.bounds;
    [self.imageSong insertSubview:_blurEffectView atIndex:0];
    [self.imageSong sd_setImageWithURL:[NSURL URLWithString:_pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    self.centerImage.layer.cornerRadius = 90;
    self.centerImage.layer.masksToBounds = YES;
    self.centerImage.image = self.imageSong.image;
  
    if (model == nil) {
        self.lblSinger.text = @"微乐提醒";
        self.lblSongName.text = @"没有选择播放的歌曲";
        self.lblCurrentTime.text = @"00:00";
        self.lblDuratiionTime.text = @"00:00";
        self.sliderBar.value = 0;
        return;
    }
    
    self.lblSongName.text = model.song_name;
    self.lblSinger.text = model.singer_name;
    //处理歌名过长的情况
    self.lblSong_Height.constant = [self getTextHeight:_lblSongName.text] > 21 ? 42 : 21;
    
    
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    //从bottomPlayView正在播放过来
    if (bpv.playerItem.status == AVPlayerStatusReadyToPlay) {
        bpv.ASTimer = ^(AVPlayerItem *item) {
            [self handleActionTime:item];
        };
    } else {
        [[BottomPlayView shareBottomPlayView] setupPlayerWithModel:model];
        bpv.ASTimer = ^(AVPlayerItem *item) {
            [self handleActionTime:item];
        };
    }
    //播放下一首
    bpv.NextSong = ^() {
        //给系统一个延迟，准备播放下一首(如果不延迟，将不能自己播放下一首ps:或许player还没有准备好播放)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (isRandom) {
                [self randomPlaySong];
            } else {
                [self nextSong];
            }
        });
    };
}
#pragma mark 计时器
- (void)handleActionTime:(AVPlayerItem *)newItem {
    [_btnPlay setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    self.lblDuratiionTime.text = [self timeformatFromSeconds:CMTimeGetSeconds(newItem.duration)];
    self.lblCurrentTime.text = [self timeformatFromSeconds:CMTimeGetSeconds(newItem.currentTime)];
    //这里需要存储一下当前的playerItem,以便pop时，还给bottomView
    _currentItem = newItem;
    _sliderBar.maximumValue = CMTimeGetSeconds(newItem.duration);
    _sliderBar.value = CMTimeGetSeconds(newItem.currentTime);
    [UIView animateWithDuration:2 animations:^{
        self.centerImage.transform = CGAffineTransformRotate(self.centerImage.transform, M_PI / 90);
    }];
}
#pragma mark 获取文本高度
- (CGFloat)getTextHeight:(NSString *)txt {
    return  [txt boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 116 - 35, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil].size.height;
}

//时间格式化
- (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    NSInteger totalm = seconds/(60);
    NSInteger h = totalm/(60);
    NSInteger m = totalm%(60);
    NSInteger s = seconds%(60);
    if (h == 0) {
        return  [NSString stringWithFormat:@"%02ld:%02ld", (long)m, (long)
                 s];
    }
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)h, (long)m, (long)s];
}

@end
