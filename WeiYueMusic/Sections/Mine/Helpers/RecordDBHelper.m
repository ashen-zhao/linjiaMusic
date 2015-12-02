//
//  DBHelper.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/16.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "RecordDBHelper.h"
#import "AppDelegate.h"

@interface RecordDBHelper()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end
@implementation RecordDBHelper

+ (NSManagedObjectContext *)getContext{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

//获取插入的实体对象
+ (PlayRecordEntity *)getRecordEntity {
    //创建实体
    NSEntityDescription *descri = [NSEntityDescription entityForName:@"PlayRecordEntity" inManagedObjectContext:[self getContext]];
    //创建实体对象
    PlayRecordEntity *entity = [[PlayRecordEntity alloc] initWithEntity:descri insertIntoManagedObjectContext:[self getContext]];
    return entity;
}
//插入实体
+ (void)insertWithRecordEntity:(PlayRecordEntity *)recordEntity {
    NSArray *list = [self getListDataWithWhere:[NSString stringWithFormat:@"songID = %@  and songFrom = '%@'", recordEntity.songID, recordEntity.songFrom]];
    //如果存在，先删除，在添加
    if (list.count >= 1) {
        [self deleteWithRecordEntity:[list firstObject]];
    } else {
        [self addEntity:recordEntity];
    }
    
}
//执行插入实体
+ (void)addEntity:(PlayRecordEntity *)recordEntity {
    NSArray *list = [self getListDataWithWhere:[NSString stringWithFormat:@"songFrom = '%@'", @"playRecord"]];
    //播放记录大于50条，就删除之前的一条
    if (list.count > 30) {
        [self deleteWithRecordEntity:list[29]];
        return;
    }
    [[self getContext] save:nil];
}

+ (NSArray *)getListDataWithWhere:(NSString *)where {
    NSFetchRequest *fetchRequet = [[NSFetchRequest alloc] initWithEntityName:@"PlayRecordEntity"];
    if (![where isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:where];
        [fetchRequet setPredicate:predicate];
    }
    NSSortDescriptor *sortDescr = [NSSortDescriptor sortDescriptorWithKey:@"autoID" ascending:NO];
    [fetchRequet setSortDescriptors:@[sortDescr]];
    return [[self getContext] executeFetchRequest:fetchRequet error:nil];
}

+ (void)deleteWithRecordEntity:(PlayRecordEntity *)recordEntity{
    [[self getContext] deleteObject:recordEntity];
    [[self getContext] save:nil];
}
@end
