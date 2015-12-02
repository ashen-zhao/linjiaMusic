//
//  SongTypeCollectionViewCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "SongTypeCollectionViewCell.h"
#import "SongTypeModel.h"
#import "UIImageView+WebCache.h"

@implementation SongTypeCollectionViewCell


- (void)setModel:(SongTypeModel *)model {
    self.lblTitle.text = model.songlist_name;
    [self.typeImage sd_setImageWithURL:[NSURL URLWithString:model.pic_url_240_200] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
}
@end
