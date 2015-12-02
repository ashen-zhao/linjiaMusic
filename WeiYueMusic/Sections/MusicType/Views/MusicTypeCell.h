//
//  MusicTypeCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicTypeModel.h"
@interface MusicTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTypeName;
@property (nonatomic, strong) MusicTypeModel *model;

@end
