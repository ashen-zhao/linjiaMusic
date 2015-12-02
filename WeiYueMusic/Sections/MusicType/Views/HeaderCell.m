 //
//  HeaderCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "HeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation HeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserDict:(NSDictionary *)userDict {
    [self.listBgkImage sd_setImageWithURL:[NSURL URLWithString:[userDict[@"pics"] firstObject]] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    [self.typeImage sd_setImageWithURL:[NSURL URLWithString:[userDict[@"pics"] firstObject]] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    self.lblDesc.text = [userDict[@"nick_name"] stringByReplacingOccurrencesOfString:@"动听" withString:@"微乐"];
    self.lblSongCount.text = [userDict[@"label"] stringByReplacingOccurrencesOfString:@"动听" withString:@"微乐"];
}

@end
