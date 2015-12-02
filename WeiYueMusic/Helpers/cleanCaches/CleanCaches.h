//
//  CleanCaches.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CleanCaches : NSObject

/**
 *  返回path路径下文件的文件大小。
 */
+ (double)sizeWithFilePath:(NSString *)path;

/**
 *  删除path路径下的文件。
 */
+ (void)clearCachesWithFilePath:(NSString *)path;
/**
 * 删除文件夹下所有文件
 */
+ (void)clearSubfilesWithFilePath:(NSString *)path;
/**
 *  获取沙盒Library的文件目录。
 */
+ (NSString *)LibraryDirectory;

/**
 *  获取沙盒Document的文件目录。
 */
+ (NSString *)DocumentDirectory;

/**
 *  获取沙盒Preference的文件目录。
 */
+ (NSString *)PreferencePanesDirectory;

/**
 *  获取沙盒Caches的文件目录。
 */
+ (NSString *)CachesDirectory;


@end
