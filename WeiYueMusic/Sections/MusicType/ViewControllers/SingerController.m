//
//  SingerController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "SingerController.h"
#import "SingerCell.h"
#import "SingerModel.h"
#import "NetworkHelper.h"
#import "BottomPlayView.h"
#import "MusicListController.h"

@interface SingerController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation SingerController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    [self.view addSubview:bpv];
    [self.view  bringSubviewToFront:bpv];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    self.dataSourceArr = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = leftBack;
    
    [self readSingerData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingerModel *model = _dataSourceArr[indexPath.row];
    SingerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singerCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingerModel *model = _dataSourceArr[indexPath.row];
    MusicListController *listTV = [self.storyboard instantiateViewControllerWithIdentifier:@"sbList"];
    listTV.from = @"singerMusic";
    listTV.navigation = self.navigation;
    listTV.navTitile = model.singer_name;
    listTV.pic_url = model.pic_url;
    listTV.msg_id = [NSString stringWithFormat:@"%@", model.singer_id];
    [self.navigation pushViewController:listTV animated:YES];

}

#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}

#pragma mark 数据类
//读取数据
- (void)readSingerData {
  
    [NetworkHelper JsonDataWithUrl:  [NSString stringWithFormat:@"http://v1.ard.tj.itlily.com/ttpod?a=getnewttpod&id=%@&size=1000&page=1", self.singerTypeID] success:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            SingerModel *model = [SingerModel new];
            [model setValuesForKeysWithDictionary:dict];
            [_dataSourceArr addObject:model];
        }
        [self.tableView reloadData];
    } fail:^{
        
    } view:self.view parameters:nil];
}
@end
