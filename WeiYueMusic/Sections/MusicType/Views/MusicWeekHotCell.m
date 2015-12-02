//
//  MusicWeekHotCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicWeekHotCell.h"
#import "UIImageView+WebCache.h"
#import "WeekMusicModel.h"


@implementation MusicWeekHotCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WeekMusicModel *)model {
    self.lblWeekTitle.text = [model.title stringByReplacingOccurrencesOfString:@"动听" withString:@"微乐"];
    [self.weekImage sd_setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    self.lblSongFirst.text = [NSString stringWithFormat:@"1.%@", model.songlist[0][@"songName"]];
     self.lblSongSecond.text = [NSString stringWithFormat:@"2.%@", model.songlist[1][@"songName"]];
     self.lblSongThird.text = [NSString stringWithFormat:@"3.%@", model.songlist[2][@"songName"]];
}
@end
