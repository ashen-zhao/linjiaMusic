//
//  OpenSearchController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/16.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "OpenSearchController.h"
#import "SearchController.h"
#import "NetworkHelper.h"


@interface OpenSearchController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (weak, nonatomic) IBOutlet UIButton *titleOne;
@property (weak, nonatomic) IBOutlet UIButton *titleTwo;
@property (weak, nonatomic) IBOutlet UIButton *titleThree;
@property (weak, nonatomic) IBOutlet UIButton *titleFour;
@property (weak, nonatomic) IBOutlet UIButton *titleFive;
@property (weak, nonatomic) IBOutlet UIButton *titleSix;

@end

@implementation OpenSearchController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataSourceArr.count > 0) {
        return;
    }
    [self readSearchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArr = [NSMutableArray array];
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnOpenSearchAction:(id)sender {
    SearchController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"sbSearch"];
    search.navigation = self.navigation;
    search.keyword = @"  ";
    [self.navigation pushViewController:search animated:YES];
}

//禁止编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return NO;
}


#pragma mark - Action
- (IBAction)btnOpenSearch:(UIButton *)sender {
    SearchController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"sbSearch"];
    search.navigation = self.navigation;
    search.keyword = [sender.currentTitle isEqualToString:@""] || sender.currentTitle == nil ? @"  " : sender.currentTitle;
    [self.navigation pushViewController:search animated:YES];
}

#pragma mark 数据类
- (void)readSearchData {
    [NetworkHelper JsonDataWithUrl:@"http://so.ard.iyyin.com/sug/billboard" success:^(id data) {
        for (NSDictionary *dict in data[@"data"]) {
            [_dataSourceArr addObject:dict[@"val"]];
        }
        [self.titleOne setTitle:_dataSourceArr[0] forState:UIControlStateNormal];
        [self.titleTwo setTitle:_dataSourceArr[1] forState:UIControlStateNormal];
        [self.titleThree setTitle:_dataSourceArr[2] forState:UIControlStateNormal];
        [self.titleFour setTitle:_dataSourceArr[3] forState:UIControlStateNormal];
        [self.titleFive setTitle:_dataSourceArr[4] forState:UIControlStateNormal];
        [self.titleSix setTitle:_dataSourceArr[5] forState:UIControlStateNormal];
    } fail:^{
        
    } view:self.view parameters:nil];
}
@end
