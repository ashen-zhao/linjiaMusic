//
//  UIImage+Scale.m
//  LessonUITableView
//
//  Created by Frank on 15/1/22.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)
//指定缩减的大小
- (UIImage *)scaleToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

@end
