//
//  NewCDCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCDModel.h"

@interface NewCDCell : UICollectionViewCell
@property (nonatomic, strong) NewCDModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbumName;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbumSinger;

@end
