//
//  RecordController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/17.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "RecordController.h"
#import "BodyCell.h"
#import "RecordDBHelper.h"
#import "PlayRecordEntity.h"
#import "MusicModel.h"
#import "BottomPlayView.h"
#import "MBProgressHUD.h"

@interface RecordController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *dataEntity;

@end

@implementation RecordController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    [self.view addSubview:bpv];
    [self.view  bringSubviewToFront:bpv];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.from isEqualToString:@"favorite"] ? @"我的喜爱" : @"最近播放";
    self.dataSourceArr = [NSMutableArray array];
    self.dataEntity = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftBack;

    [self readRecordData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicModel *model = _dataSourceArr[indexPath.row];
    BodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
    cell.lblSongName.text = model.song_name;
    cell.model = model;    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    MusicModel *model = _dataSourceArr[indexPath.row];
    bpv.dataSourceArr = [NSMutableArray arrayWithArray:_dataSourceArr];
    bpv.currentIndex = indexPath.row;
    //由于接口数据问题，只能传送用户图片，找不到歌手图片
    bpv.pic_url = @"";
    //播放
    [bpv setupPlayerWithModel:model];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
        [RecordDBHelper deleteWithRecordEntity:_dataEntity[indexPath.row]];
        [_dataEntity removeObject:_dataEntity[indexPath.row]];
        [_dataSourceArr removeObject:_dataSourceArr[indexPath.row]];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //删除后，更新一下bpv的数据源
        bpv.dataSourceArr = _dataSourceArr;
    }
}
//修改cell默认删除按钮的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath :( NSIndexPath *)indexPath{
    return @"移除歌单";
}


#pragma mark - Action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}

#pragma mark - 数据类
- (void)readRecordData {
    NSString *strWhere = [NSString stringWithFormat:@"songFrom = '%@'", @"playRecord"];
    if ([self.from isEqualToString:@"favorite"]) {
        strWhere = [NSString stringWithFormat:@"songFrom = '%@'", @"favorite"];
    }
    NSArray *list = [RecordDBHelper getListDataWithWhere:strWhere];
    _dataEntity = [NSMutableArray arrayWithArray:list];
    for (PlayRecordEntity *entity in list) {
        MusicModel *model = [[MusicModel alloc] init];
        model.song_name = entity.songName;
        model.song_id = [NSNumber numberWithInteger:[entity.songID integerValue]];
        model.singer_name = entity.songSinger;
        model.url_list = [NSMutableArray arrayWithObject:@{@"url":entity.songUrl == nil ? @"" : entity.songUrl}];
        model.pic_url = entity.songImage;
        model.pick_count = [entity.songPlayCount integerValue];
        [_dataSourceArr addObject:model];
    }
    [self.tableView reloadData];
    
}

@end
