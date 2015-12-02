//
//  MusicHotCell.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicHotCell.h"
#import "SDCycleScrollView.h"

@interface MusicHotCell()

@end

@implementation MusicHotCell
- (void)configureCycleImage:(NSMutableArray *)imageArr {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       SDCycleScrollView *viewCycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 140) imageURLsGroup:imageArr];
        viewCycle.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        viewCycle.delegate = self;
        viewCycle.autoScrollTimeInterval = 6;
        viewCycle.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        viewCycle.placeholderImage = [UIImage imageNamed:@"effect_env_none.jpg"];
        [self.cycleView addSubview:viewCycle];
    });
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.currentIndex) {
        self.currentIndex(index);
    }
}

@end
