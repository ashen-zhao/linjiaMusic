//
//  MusicTypeViewController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicTypeViewController.h"
#import "MusicTypeCell.h"
#import "MusicTypeModel.h"
#import "MusicWeekController.h"
#import "MusicListController.h"
#import "NewCDController.h"
#import "SingerTypeController.h"
#import "SongTypeController.h"

@interface MusicTypeViewController ()
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation MusicTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除tableView的分割线
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.dataSourceArray = [NSMutableArray array];
    [self readMustcTypeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicTypeModel *model = _dataSourceArray[indexPath.row];
    MusicTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicTypeCell" forIndexPath:indexPath];
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   MusicTypeModel *model = _dataSourceArray[indexPath.row];
    if (indexPath.row == 0) {
        NewCDController *cdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbCollection"];
        cdVC.navigation = self.navigation;
        cdVC.navTitle = @"新歌首发";
        [self.navigation pushViewController:cdVC animated:YES];
    } else if(indexPath.row == 1) {
        MusicWeekController *weekList = [self.storyboard  instantiateViewControllerWithIdentifier:@"sbWeek"];
        weekList.navigation = self.navigation;
        weekList.navTitile = model.typeName;
        [self.navigation pushViewController:weekList animated:YES];
    } else if(indexPath.row == 2) {
        SingerTypeController *singerVC = [self.storyboard  instantiateViewControllerWithIdentifier:@"sbSingerType"];
        singerVC.navigation = self.navigation;
        singerVC.navTitle = model.typeName;
        [self.navigation pushViewController:singerVC animated:YES];
    } else if(indexPath.row == 3) {
        SongTypeController *songVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbSongType"];
        songVC.navigation = self.navigation;
        songVC.navTitle = model.typeName;
        [self.navigation pushViewController:songVC animated:YES];
    } else {
        MusicListController *listTV = [self.storyboard instantiateViewControllerWithIdentifier:@"sbList"];
        listTV.from = @"songType";
        listTV.msg_id = @"3";
        listTV.navigation = self.navigation;
        listTV.navTitile = @"大家在听";
        listTV.pic_url = @"http://wwww.zhaoashen.com"; //假数据
        [self.navigation pushViewController:listTV animated:YES];
    }
  
}

//处理最后一个cell被覆盖50
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

#pragma mark 数据类
//读取数据
- (void)readMustcTypeData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"musicType" ofType:@"plist"];
   
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in dataArr) {
        MusicTypeModel *model = [MusicTypeModel new];
        [model setValuesForKeysWithDictionary:dict];
        [_dataSourceArray addObject:model];
    }
    [self.tableView reloadData];
}


@end
