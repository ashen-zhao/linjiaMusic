//
//  ThreeeImageCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "ThreeeImageCell.h"
#import "MusicHotModel.h"
#import "UIImageView+WebCache.h"


@implementation ThreeeImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureCell:(NSMutableArray *)dataArr {
    self.lblLeftCount.text = [NSString stringWithFormat:@"❤️%@", ((MusicHotModel *)dataArr[0]).listen_count];
    self.lblCenterCount.text =  [NSString stringWithFormat:@"❤️%@", ((MusicHotModel *)dataArr[1]).listen_count];
    self.lblLeftDesc.text = ((MusicHotModel *)dataArr[0]).desc;
    self.lblCenterDesc.text = ((MusicHotModel *)dataArr[1]).desc;
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:((MusicHotModel *)dataArr[0]).pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    [self.centerImage sd_setImageWithURL:[NSURL URLWithString:((MusicHotModel *)dataArr[1]).pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    

    self.lblRightCount.text = [NSString stringWithFormat:@"❤️%@", ((MusicHotModel *)dataArr[2]).listen_count];
    

    self.lblRightDesc.text = ((MusicHotModel *)dataArr[2]).desc;
    

    [self.rightImage sd_setImageWithURL:[NSURL URLWithString:((MusicHotModel *)dataArr[2]).pic_url] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    
    
}

@end
