//
//  MusicWeekController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicWeekController.h"
#import "MusicWeekHotCell.h"
#import "BottomPlayView.h"
#import "MusicListController.h"
#import "NetworkHelper.h"
#import "WeekMusicModel.h"

@interface MusicWeekController ()<UITableViewDataSource, UITableViewDelegate> {
    UIImageView *imageBgk;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation MusicWeekController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];//[[BottomPlayView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    [self.view addSubview:bpv];
    [self.view bringSubviewToFront:bpv];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    self.navigationItem.title = self.navTitile;
    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftBack;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    imageBgk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network-disabled"]];
    imageBgk.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.tableView addSubview:imageBgk];
    [self readWeekMusicData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekMusicModel *model = _dataSourceArr[indexPath.row];
    MusicWeekHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weekCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekMusicModel *model = _dataSourceArr[indexPath.row];
    MusicListController *listTV = [self.storyboard instantiateViewControllerWithIdentifier:@"sbList"];
    listTV.from = @"weekMusic";
    listTV.navigation = self.navigation;
    listTV.navTitile = model.title;
    listTV.msg_id = model.ID;
    listTV.pic_url = model.pic_url;
    [self.navigation pushViewController:listTV animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}

#pragma mark -数据类
- (void)readWeekMusicData {
    [NetworkHelper JsonDataWithUrl:@"http://v1.ard.tj.itlily.com/ttpod?a=getnewttpod&id=281" success:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            WeekMusicModel *model = [WeekMusicModel new];
            [model setValuesForKeysWithDictionary:dict];
            
            [_dataSourceArr addObject:model];
        }
        [self.tableView reloadData];
        [imageBgk removeFromSuperview];
        imageBgk = nil;
    } fail:^{
        
    } view:self.view parameters:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
