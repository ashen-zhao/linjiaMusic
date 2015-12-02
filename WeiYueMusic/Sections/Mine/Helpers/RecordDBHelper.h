//
//  DBHelper.h
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/16.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayRecordEntity.h"

@interface RecordDBHelper : NSObject

+ (void)insertWithRecordEntity:(PlayRecordEntity *)recordEntity;

+ (NSArray *)getListDataWithWhere:(NSString *)where;

+ (void)deleteWithRecordEntity:(PlayRecordEntity *)recordEntity;

+ (PlayRecordEntity *)getRecordEntity;
@end
