//
//  MusicHotCell.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface MusicHotCell : UITableViewCell<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cycleView;
- (void)configureCycleImage:(NSMutableArray *)imageArr;
@property (nonatomic, copy) void(^currentIndex)(NSInteger index);
@end
