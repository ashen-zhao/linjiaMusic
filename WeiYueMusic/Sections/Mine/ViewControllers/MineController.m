//
//  MineController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MineController.h"
#import "MineCell.h"
#import "RecordDBHelper.h"
#import "PlayRecordEntity.h"
#import "RecordController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "CleanCaches.h"

@interface MineController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataName;
@property (nonatomic, strong) NSMutableArray *dataImage;

@end

@implementation MineController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataImage = [NSMutableArray arrayWithObjects:@"", @"icon_posted@2x",@"icon_icommentd@2x", @"icon_nightmode@2x", @"icon_posted@2x",  @"icon_myfriends@2x", nil];
    self.dataName = [NSMutableArray arrayWithObjects: @"", @"最近播放", @"我的喜爱", @"清除缓存", @"免责声明", @"关于我", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView =  [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell" forIndexPath:indexPath];
    cell.titleImage.image = [UIImage imageNamed:_dataImage[indexPath.row]];
    cell.lblTitle.text = _dataName[indexPath.row];
    cell.lblCount.text = @"";
    tableView.rowHeight = 50;
    if (indexPath.row == 1) {
        cell.lblCount.text = [NSString stringWithFormat:@"%ld首歌", (unsigned long)[[RecordDBHelper getListDataWithWhere:@"songFrom = 'playRecord'"] count]];
    } else if (indexPath.row == 2) {
        cell.lblCount.text =  cell.lblCount.text = [NSString stringWithFormat:@"%ld首歌", (unsigned long)[[RecordDBHelper getListDataWithWhere:@"songFrom = 'favorite'"] count]];
    } else if(indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordController *record = [self.storyboard instantiateViewControllerWithIdentifier:@"sbRecord"];
    record.navigation = self.navigation;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        record.from = @"playRecord";
        [self.navigation pushViewController:record animated:YES];
    } else if (indexPath.row == 2) {
        record.from = @"favorite";
        [self.navigation pushViewController:record animated:YES];
    } else if (indexPath.row == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"真的要清除吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    } else if (indexPath.row == 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本APP旨在技术分享，不涉及任何商业利益。" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (indexPath.row == 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"APP开发者：赵阿申\n邮箱：zhaoashen@gmail.com" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

#pragma mark Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [self.view addSubview:hud];
        //加载条上显示文本
        hud.labelText = @"急速清理中";
        //设置对话框样式
        hud.mode = MBProgressHUDModeDeterminate;
        [hud showAnimated:YES whileExecutingBlock:^{
            while (hud.progress < 1.0) {
                hud.progress += 0.01;
                [NSThread sleepForTimeInterval:0.02];
            }
            hud.labelText = @"清理完成";
        } completionBlock:^{
            //清除本地
            //清除caches文件下所有文件
            [CleanCaches clearSubfilesWithFilePath:[CleanCaches CachesDirectory]];
            //清除内存
            [[SDImageCache sharedImageCache] clearMemory];
            [self.tableView reloadData];
            [hud removeFromSuperview];
        }];
        
        
    }
}

@end
