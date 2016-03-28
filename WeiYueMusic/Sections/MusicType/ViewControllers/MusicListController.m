//
//  MusicListController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicListController.h"
#import "HeaderCell.h"
#import "BottomPlayView.h"
#import "BodyCell.h"
#import "NetworkHelper.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"

@interface MusicListController ()<UITableViewDelegate, UITableViewDataSource> {
    NSInteger pIndex; //上次播放的索引
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableDictionary *userDict;
@end

@implementation MusicListController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    [self.view addSubview:bpv];
    [self.view  bringSubviewToFront:bpv];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    pIndex = -1; //处理row==0的情况
    self.dataSourceArr = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = self.navTitile;
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];    
    self.navigationItem.leftBarButtonItem = leftBack;
    [self readMusicListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : _dataSourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        HeaderCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        cell.typeImage.layer.cornerRadius = cell.typeImage.frame.size.width / 2;
        cell.typeImage.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userDict = _userDict;
        return cell;
        
    } else {
        MusicModel *model = _dataSourceArr[indexPath.row];
        BodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bodyCell" forIndexPath:indexPath];
        cell.lblSongName.text = [NSString stringWithFormat:@"%d. %@", (int)indexPath.row + 1, model.song_name];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //处理，点击的还是同一首歌
        if (pIndex != indexPath.row) {
            BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
            MusicModel *model = _dataSourceArr[indexPath.row];
            
            bpv.dataSourceArr = _dataSourceArr;
            bpv.currentIndex = indexPath.row;
            //由于接口数据问题，只能传送用户图片，找不到歌手图片
            bpv.pic_url = [_userDict[@"pics"] firstObject];
            //播放
            [bpv setupPlayerWithModel:model];
            pIndex = indexPath.row;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    } else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 50 : 0;
}

#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}


#pragma mark - 数据类
- (void)readMusicListData {
    
//来自排行
    if ([self.from isEqualToString:@"weekMusic"]) {
         [self readDataByFrom:[NSString stringWithFormat:@"http://api.dongting.com/channel/ranklist/%@/songs?page=1", self.msg_id]];
    } else if ([self.from isEqualToString:@"singerMusic"]) {
        [self readDataByFrom:[NSString stringWithFormat:@"http://api.dongting.com/song/singer/%@/songs?page=1&size=50",self.msg_id]];
    } else if ([self.from isEqualToString:@"songType"]) {
        [self readDataByFrom:[NSString stringWithFormat:@"http://api.dongting.com/channel/channel/%@/songs?size=50&page=1", self.msg_id]];
    } else {
         [NetworkHelper JsonDataWithUrl:[NSString stringWithFormat:@"http://api.songlist.ttpod.com/songlists/%@", self.msg_id]success:^(id data) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dict in data[@"songs"]) {
                //存放用户信息
                self.userDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"user"]];
                [_userDict setValue:dict[@"pics"] forKey:@"pics"];
                for (NSDictionary *dict1 in dict[@"songlist"]) {
                    [tempArr addObject:dict1[@"_id"]];
                }
                MusicModel *model = [MusicModel new];
                [model setValuesForKeysWithDictionary:dict];
                [_dataSourceArr addObject:model];
            }
            [self.tableView reloadData];
            
//            [NetworkHelper JsonDataWithUrl:[NSString stringWithFormat:@"http://ting.hotchanson.com/songs/downwhite?song_id=%@", [tempArr componentsJoinedByString:@","]] success:^(id data) {
//                for (NSDictionary *dict in data[@"data"]) {
//                    MusicModel *model = [MusicModel new];
//                    [model setValuesForKeysWithDictionary:dict];
//                    
//                    [_dataSourceArr addObject:model];
//                }
//                [self.tableView reloadData];
//            } fail:^{
//                
//            } view:self.view parameters:nil];
            
        } fail:^{
            
        } view:self.view parameters:nil];
    }
}

- (void)readDataByFrom:(NSString *)fromUrl {
    [NetworkHelper JsonDataWithUrl:fromUrl success:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            MusicModel *model = [MusicModel new];
            [model setValuesForKeysWithDictionary:dict];
            [_dataSourceArr addObject:model];
        }
        self.userDict = [NSMutableDictionary dictionaryWithObjects:@[@[self.pic_url], self.navTitile, [NSString stringWithFormat:@"共%ld首歌", (unsigned long)_dataSourceArr.count]] forKeys:@[@"pics", @"nick_name", @"label"]];
        
        [self.tableView reloadData];
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
