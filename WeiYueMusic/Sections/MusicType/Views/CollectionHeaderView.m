//
//  CollectionHeaderView.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lblTitle];
    }
    return self;
}
- (UILabel *)lblTitle {
    if (!_lblTitle) {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width, 35)];
        _lblTitle.font = [UIFont systemFontOfSize:18];
    }
    return _lblTitle;
}
@end
