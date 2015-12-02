//
//  SingerCollectionCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingerTypeModel;

@interface SingerCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UILabel *lblNameTag;

@property (nonatomic, strong) SingerTypeModel *model;

@end
