//
//  MusicSingerController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/13.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "SingerTypeController.h"
#import "SingerCollectionCell.h"
#import "SingerTypeModel.h"
#import "NetworkHelper.h"
#import "BottomPlayView.h"
#import "SingerController.h"

@interface SingerTypeController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    UIImageView *imageBgk;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation SingerTypeController
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
    _layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40) / 3, ([UIScreen mainScreen].bounds.size.width - 40) / 3 + 30);
    _layout.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = leftBack;
    imageBgk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network-disabled"]];
    imageBgk.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.collectionView addSubview:imageBgk];
    [self readSingerTypeData];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SingerTypeModel *model = _dataSourceArr[indexPath.row];
    static NSString *iden = @"singerItem";
    SingerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     SingerTypeModel *model = _dataSourceArr[indexPath.row];
    SingerController *singerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbSinger"];
    singerVC.navigation = self.navigation;
    singerVC.singerTypeID = model.ID;
    singerVC.navTitle = model.title;
    [self.navigation pushViewController:singerVC animated:YES];
}
#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}

#pragma mark -数据类
//读取网络数据
- (void)readSingerTypeData {
    [NetworkHelper JsonDataWithUrl:@"http://v1.ard.tj.itlily.com/ttpod?a=getnewttpod&id=46" success:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            SingerTypeModel *model = [SingerTypeModel new];
            [model setValuesForKeysWithDictionary:dict];
            [_dataSourceArr addObject:model];
        }
        [self.collectionView reloadData];
        [imageBgk removeFromSuperview];
        imageBgk  = nil;
    } fail:^{
        
    } view:self.view parameters:nil];
}



@end
