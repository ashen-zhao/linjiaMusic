//
//  NewCDController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/12.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "NewCDController.h"
#import "NewCDCell.h"
#import "NetworkHelper.h"
#import "NewCDModel.h"
#import "MusicListController.h"
#import "BottomPlayView.h"

@interface NewCDController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    UIImageView *imageBgk;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation NewCDController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    [self.view addSubview:bpv];
    [self.view bringSubviewToFront:bpv];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftBack;
    self.navigationItem.title = self.navTitle;
    
    self.dataSourceArr = [NSMutableArray array];
    
     _layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 24) / 2, ([UIScreen mainScreen].bounds.size.width - 24) / 2 + 45);
    _layout.sectionInset = UIEdgeInsetsMake(5, 8, 0, 8);
    _layout.minimumInteritemSpacing = 8;
    self.collectionView.dataSource = self;
    _collectionView.delegate = self;
    imageBgk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network-disabled"]];
    imageBgk.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.collectionView addSubview:imageBgk];
    [self readNewCDData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollectionViewDataSource

//设置分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
//针对于每个item返回cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewCDModel *model = _dataSourceArr[indexPath.row];
    NewCDCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"collectionCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegate

//item选中事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NewCDModel *model = _dataSourceArr[indexPath.row];
    MusicListController *listTV = [self.storyboard instantiateViewControllerWithIdentifier:@"sbList"];
    listTV.navigation = self.navigation;
    listTV.msg_id = model.msg_id;
    listTV.navTitile = model.desc;
    [self.navigation pushViewController:listTV animated:YES];
}


#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}


#pragma mark - 读取数据
- (void)readNewCDData {
    [NetworkHelper JsonDataWithUrl:@"http://online.dongting.com/recomm/new_albums?page=1&size=30" success:^(id data) {
        for (NSDictionary *dict in  data[@"data"]) {
            NewCDModel *model = [NewCDModel new];
            [model setValuesForKeysWithDictionary:dict];
            [_dataSourceArr addObject:model];
        }
        [self.collectionView reloadData];
        [imageBgk removeFromSuperview];
        imageBgk = nil;
    } fail:^{
        
    } view:self.view parameters:nil];
}

@end
