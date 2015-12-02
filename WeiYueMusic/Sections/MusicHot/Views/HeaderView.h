//
//  HeaderView.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *sectionTitle;

+ (id)headerView:(UITableView *)tableView;

@end
