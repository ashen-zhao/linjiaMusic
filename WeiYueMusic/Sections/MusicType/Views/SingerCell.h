//
//  SingerCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingerModel;

@interface SingerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, strong) SingerModel *model;

@end
