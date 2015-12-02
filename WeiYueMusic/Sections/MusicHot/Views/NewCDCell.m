//
//  NewCDCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "NewCDCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Scale.h"

@implementation NewCDCell

- (void)setModel:(NewCDModel *)model {
    //网落图片太大， 在这里为了防止内存警告，每次请求清除一下内存
    [[SDImageCache sharedImageCache] clearMemory];
    [self.albumImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    self.lblAlbumSinger.text = [model.desc componentsSeparatedByString:@"-"][0];
    self.lblAlbumName.text = [model.desc componentsSeparatedByString:@"-"][1];
}
@end
