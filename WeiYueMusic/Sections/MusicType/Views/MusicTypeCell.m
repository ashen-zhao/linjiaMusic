//
//  MusicTypeCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicTypeCell.h"

@implementation MusicTypeCell


- (void)setModel:(MusicTypeModel *)model {
//    self.typeImage.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.typeImage.layer.shadowOffset = CGSizeMake(0,0);
//    self.typeImage.layer.shadowOpacity = 3.0;
//    self.typeImage.layer.shadowRadius= 1.5;
    self.typeImage.image = [UIImage imageNamed:model.typeImageName];
    _typeImage.layer.cornerRadius = 3;
    _typeImage.layer.masksToBounds = YES;
    self.lblTypeName.text = model.typeName;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
