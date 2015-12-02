//
//  SongTypeController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "SongTypeController.h"
#import "BottomPlayView.h"
#import "SongTypeModel.h"
#import "SongTypeCollectionViewCell.h"
#import "NetworkHelper.h"
#import "CollectionHeaderView.h"
#import "MusicListController.h"

@interface SongTypeController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    UIImageView *imageBgk;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *dataSection;
@property (nonatomic, strong) NSString *preTypeName; //记录上一条信息的类别
@end

@implementation SongTypeController

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
    self.dataSection = [NSMutableArray array];
    _layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40) / 3, ([UIScreen mainScreen].bounds.size.width - 40) / 3 + 28);
    _layout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = leftBack;
    self.preTypeName = @"热门";
    [self.collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    imageBgk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network-disabled"]];
    imageBgk.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.collectionView addSubview:imageBgk];
    [self readSongTypeData];

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


#pragma mark - DataSourceDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSection.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSourceArr[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SongTypeModel *model = _dataSourceArr[indexPath.section][indexPath.row];
    static NSString *iden = @"songTypeItem";
    SongTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.lblTitle.text = _dataSection[indexPath.section];
        reusableview = headerView;
    }
    
    return reusableview;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SongTypeModel *model = _dataSourceArr[indexPath.section][indexPath.row];
    MusicListController *list = [self.storyboard instantiateViewControllerWithIdentifier:@"sbList"];
    list.from = @"songType";
    list.navigation = self.navigation;
    list.navTitile = model.songlist_name;
    list.pic_url = model.pic_url_240_200;
    list.msg_id = [NSString stringWithFormat:@"%@", model.songlist_id];
    [self.navigation pushViewController:list animated:YES];
}

#pragma mark - action 
#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}

#pragma mark 数据类；
- (void)readSongTypeData {
    
    [NetworkHelper JsonDataWithUrl:@"http://fm.api.ttpod.com/channellist?image_type=240_200" success:^(id data) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in data[@"data"]) {
            SongTypeModel *model = [SongTypeModel new];
            [model setValuesForKeysWithDictionary:dict];
            if (![_preTypeName isEqualToString:model.parentname]) {
                [_dataSection addObject:model.parentname];
                [_dataSourceArr addObject:tempArr];
                tempArr = [NSMutableArray array];
            }
            [tempArr addObject:model];
            _preTypeName = model.parentname;
        }
        [self.collectionView reloadData];
        [imageBgk removeFromSuperview];
        imageBgk = nil; 
    } fail:^{
        
    } view:self.view parameters:nil];
}
@end
