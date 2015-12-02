//
//  MusicWeekHotCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeekMusicModel;

@interface MusicWeekHotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *weekImage;
@property (weak, nonatomic) IBOutlet UILabel *lblWeekTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSongFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblSongSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblSongThird;

@property (nonatomic, strong) WeekMusicModel *model;

@end
