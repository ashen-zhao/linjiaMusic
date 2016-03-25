//
//  WebPageViewController.h
//  Shou65
//
//  Created by ashen on 15/6/4.
//  Copyright (c) 2015年 ashen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController
@property (nonatomic, strong) UINavigationController *navigation;
@property (nonatomic, strong) NSString *urlString;
@end
