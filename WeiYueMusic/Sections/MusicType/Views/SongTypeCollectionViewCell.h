//
//  SongTypeCollectionViewCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongTypeModel;

@interface SongTypeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) SongTypeModel *model;
@end
