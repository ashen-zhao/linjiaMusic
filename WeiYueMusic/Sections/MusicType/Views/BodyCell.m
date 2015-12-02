//
//  BodyCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "BodyCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"

@implementation BodyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MusicModel *)model {
//    [self.songImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    self.lblSingerName.text = model.singer_name;
    self.lblFavoriteCount.text = [NSString stringWithFormat:@"%ld", (long)model.pick_count];
//    NSInteger tempInt = model.pick_count;
//    if (tempInt == 0) {
//    } else if (tempInt < 10000){
//         self.lblFavoriteCount.text = [NSString stringWithFormat:@"%li",tempInt];
//    } else {
//        NSInteger temp = tempInt / 10000;
//        tempInt = tempInt % 10000 / 1000;
//        self.lblFavoriteCount.text = [NSString stringWithFormat:@"%li.%li万",temp, tempInt];
//    }
}
@end
