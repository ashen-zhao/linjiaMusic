//
//  HeaderView.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView()
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation HeaderView

//处理headerView重用
+ (id)headerView:(UITableView *)tableView {
    static NSString *iden = @"header";
    HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:iden];
    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:iden];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.lblTitle = [[UILabel alloc] init];
        _lblTitle.backgroundColor = [UIColor whiteColor];
        _lblTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:_lblTitle];
        
        self.lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor redColor];
        [self addSubview:_lineView];
    }
    return self;
}


- (void)layoutSubviews {
    self.lblTitle.frame = CGRectMake(16, 2, self.frame.size.width, 10);
    self.lineView.frame = CGRectMake(8, 0, 2, 15);
}

- (void)setSectionTitle:(NSString *)sectionTitle {
    self.lblTitle.text = sectionTitle;
    
}

@end
