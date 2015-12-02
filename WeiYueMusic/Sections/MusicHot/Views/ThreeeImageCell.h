//
//  ThreeeImageCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeeImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCenterCount;
@property (weak, nonatomic) IBOutlet UILabel *lblRightCount;

@property (weak, nonatomic) IBOutlet UILabel *lblLeftDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblCenterDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblRightDesc;


- (void)configureCell:(NSMutableArray *)dataArr;
@end
