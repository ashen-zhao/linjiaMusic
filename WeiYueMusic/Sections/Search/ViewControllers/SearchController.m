//
//  SearchController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/16.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "SearchController.h"
#import "MusicModel.h"
#import "BodyCell.h"
#import "NetworkHelper.h"
#import "BottomPlayView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface SearchController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
//@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *ASSearchBar;

@end

@implementation SearchController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    [self.view addSubview:bpv];
    [self.view  bringSubviewToFront:bpv];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"想听就搜呗";
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftBack;
    //禁止手势返回
//    self.fd_interactivePopDisabled = YES;
    
    self.dataSourceArr = [NSMutableArray array];
    self.tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    _searchController.searchResultsUpdater = self;
//    _searchController.dimsBackgroundDuringPresentation = YES; //开始搜索时，背景显示与否
//    [_searchController.searchBar sizeToFit];
//    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    _searchController.searchBar.placeholder = @"歌曲/歌手/专辑";
////    _searchController.searchBar.delegate = self;
    
    self.navigationItem.titleView = _ASSearchBar;
    if (![self.keyword isEqualToString:@"  "]) {
        _ASSearchBar.text = self.keyword;
    }
  
    _ASSearchBar.delegate = self;
    [_ASSearchBar sizeToFit];
   [self readSearchData:self.keyword];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma delegate 方法
//tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //在这里处理一下，用户过快的故意搜索，产生的crash
    MusicModel *model = _dataSourceArr.count == 0 ? nil : _dataSourceArr[indexPath.row];
    BodyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.lblSongName.text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, model.song_name];
    cell.model = model;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    MusicModel *model = _dataSourceArr[indexPath.row];
    bpv.dataSourceArr = [NSMutableArray arrayWithArray:_dataSourceArr]; //拷贝一份
    bpv.currentIndex = indexPath.row;
    bpv.pic_url = @"http://muniu.com";
    //播放
    [bpv setupPlayerWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
//UISearchResultsUpdating
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString *filterString = searchController.searchBar.text;
//    //处理没有搜索词的情况
//    if ([filterString isEqualToString:@""] || !filterString) {
//        return;
//    }
//    
//    if (self.dataSourceArr) {
//        [self.dataSourceArr removeAllObjects];
//    }
//    [self readSearchData:filterString];
//}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //处理没有搜索词的情况
    if ([searchText isEqualToString:@""] || !searchText) {
        return;
    }
    if (self.dataSourceArr) {
        [self.dataSourceArr removeAllObjects];
    }
    //根据关键字，重新请求
    [self readSearchData:searchText];
}
//点击搜索回收键盘
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_ASSearchBar resignFirstResponder];
}

#pragma mark action
- (void)handleBack:(UIBarButtonItem *)item {
    [self.navigation popViewControllerAnimated:YES];
}

#pragma mark 数据类
- (void)readSearchData:(NSString *)keyWord {
    NSDictionary *parameDict = [NSDictionary dictionaryWithObjects:@[keyWord, @"1", @"50"] forKeys:@[@"q", @"page", @"size"]];
    
    [NetworkHelper JsonDataWithUrl:@"http://so.ard.iyyin.com/s/song_with_out" success:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            MusicModel *model = [MusicModel new];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataSourceArr addObject:model];
        }
        [self.tableView reloadData];
    } fail:^{
        
    } view:self.view parameters:parameDict];
}

@end
