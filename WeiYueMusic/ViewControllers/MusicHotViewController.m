//
//  MusicHotViewController.m
//  WeiYueMusic
//
//  Created by lanou3g on 15/7/10.
//  Copyright (c) 2015年 Ashen. All rights reserved.
//

#import "MusicHotViewController.h"
#import "MusicHotCell.h"
#import "MusicHotModel.h"
#import "MusicHotCell.h"
#import "NetworkHelper.h"
#import "SDCycleScrollView.h"
#import "SingleImageCell.h"
#import "ThreeeImageCell.h"
#import "HeaderView.h"
#import "MusicListController.h"
#import "NewCDController.h"
#import "MBProgressHUD.h"
#import "WebPageViewController.h"

@interface MusicHotViewController () {
    UIImageView *imageBgk;
}
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *dataSecion;
@property (nonatomic, strong) NSMutableArray *imageURLArr;

@end

@implementation MusicHotViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataSourceArray.count > 0) {
        return;
    }
    [self readHotData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [NSMutableArray array];
    self.dataSecion = [NSMutableArray array];
    self.imageURLArr = [NSMutableArray array];
    imageBgk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network-disabled"]];
    imageBgk.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [self.tableView addSubview:imageBgk];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 | section == 2 | section == 3 ? 1 : [_dataSourceArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicHotModel *model = _dataSourceArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        MusicHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicHotCell" forIndexPath:indexPath];
   
        [cell configureCycleImage: _imageURLArr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentIndex = ^(NSInteger index) {
            [self pushToListByMsgID:[_dataSourceArray[0][index] ID] title:[_dataSourceArray[0][index] name]];
        };
        return cell;
    } else if (indexPath.section == 2 || indexPath.section == 3)   {
        ThreeeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threeImageCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //处理接口数据不对应的情况，当内容小于的时候，就补第一个，直到为3
        while ([_dataSourceArray[indexPath.section] count] < 3) {
            [_dataSourceArray[indexPath.section] addObject:_dataSourceArray[indexPath.section][0]];
        }
        [cell configureCell:_dataSourceArray[indexPath.section]];
        return cell;
    } else {
        SingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleImageCell" forIndexPath:indexPath];
        cell.titleImage.layer.cornerRadius = 5;
        cell.titleImage.layer.masksToBounds = YES;
        cell.model = model;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160;
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        return [UIScreen mainScreen].bounds.size.width / 3 - 16 + 60;
    } else {
        return 100;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self pushToListByMsgID:@"300002376" title: [_dataSecion[indexPath.section] name]];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        NewCDController *cdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sbCollection"];
        cdVC.navigation = self.navigation;
        cdVC.navTitle = [_dataSecion[indexPath.section] name];
        [self.navigation pushViewController:cdVC animated:YES];
        
    } else if (indexPath.section == 2 ) {
    } else if (indexPath.section == 3) {
    } else {
        MusicHotModel *model = _dataSourceArray[indexPath.section][indexPath.row];
        if ([model.action[@"type"] isEqualToNumber:@(1)]) {
            WebPageViewController *web = [[WebPageViewController alloc] init];
            web.urlString = model.action[@"value"];
            web.navigation = self.navigation;
            [self.navigation pushViewController:web animated:YES];
        } else {
            [self pushToListByMsgID:model.ID  title:[_dataSecion[indexPath.section] name]];
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderView *headerView = [HeaderView headerView:tableView];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.sectionTitle = [_dataSecion[section] name];
    return section == 0 ? nil : headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1 : 20;
}
//处理最后一个cell被覆盖50
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return _dataSecion.count - 1 == section ? 50 : 0;
}



#pragma mark action 
- (IBAction)leftImageTap:(UITapGestureRecognizer *)sender {
    [self pushToList:0 sender:sender];
}
- (IBAction)centerImageTap:(id)sender {
    [self pushToList:1 sender:sender];
}
- (IBAction)rightImageTap:(id)sender {
    [self pushToList:2 sender:sender];
}
//三张图片push
- (void)pushToList:(NSInteger)row sender:(UITapGestureRecognizer *)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicListController *listTV = [storyBoard instantiateViewControllerWithIdentifier:@"sbList"];
    listTV.navigation = self.navigation;
    if ([sender locationInView:self.view].y > 590) {
        listTV.navTitile = [_dataSecion[3] name] ;
        listTV.msg_id = [_dataSourceArray[3][row] ID];
    } else {
        listTV.navTitile = [_dataSecion[2] name];
        listTV.msg_id = [_dataSourceArray[2][row] ID];
    }
    [self.navigation pushViewController:listTV animated:YES];
}

//除三张图片
- (void)pushToListByMsgID:(NSString *)msg_id title:(NSString *)title {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MusicListController *listTV = [storyBoard instantiateViewControllerWithIdentifier:@"sbList"];
    listTV.navigation = self.navigation;
    listTV.msg_id = msg_id;
    listTV.navTitile = title;
    [self.navigation pushViewController:listTV animated:YES];
}

#pragma mark - 数据类
//请求数据
- (void)readHotData {

  [NetworkHelper JsonDataWithUrl:@"http://api.dongting.com/frontpage/frontpage" success:^(id data) {
      NSArray *sectionArr = data[@"data"];
      
      
      //这是老接口处理代码，接口数据有点乱，还经常变，需要处理的比较多
      /*
      //分区标识
//      int i = 0;
//      for (NSDictionary *dict1  in sectionArr) {
//          MusicHotModel *model1 = [MusicHotModel new];
//          [model1 setValuesForKeysWithDictionary:dict1];
//          NSArray *rowArr = dict1[@"data"];
//          NSMutableArray *tempArr = [NSMutableArray array];
//          NSMutableArray *te = [NSMutableArray array];
//          for (NSDictionary *dict2 in rowArr) {
//              MusicHotModel *model2 = [MusicHotModel new];
//              [model2 setValuesForKeysWithDictionary:dict2];
//              model2.ID = model2.action[@"value"];
//
//              if ((!model2.ID && ![model1.name isEqualToString:@"最新音乐"]) || [model1.style isEqualToNumber:@(14)]) {
//                  continue;
//              }
//              
//              if ([model1.name containsString:@"网友热推"]||[model1.name containsString:@"8.0"] || [model1.name containsString:@"8.1"]) {
//                  continue;
//              }
//
//              //处理0分区,含有webView
//              if (i == 0) {
//                  [_imageURLArr addObject:[NSURL URLWithString:model2.pic_url]];
//              }
//              [te addObject:model2];
//              [tempArr addObject:model2];
//          }
//          if (te.count > 0) {
//              [_dataSecion addObject:model1];
//              [_dataSourceArray addObject:tempArr];
//          }
//          i++;
//      }
      //
      //      //由于接口数据不稳定，这里处理一下
      //      if ([[_dataSecion[1] name] isEqualToString:@"热门歌单"]) {
      //          [_dataSecion exchangeObjectAtIndex:1 withObjectAtIndex:2];
      //          [_dataSourceArray exchangeObjectAtIndex:1 withObjectAtIndex:2];
      //      }
      
  */
      
      //这是新接口处理代码，接口数据相对整齐多了，看来天天动听，换后天了么，哈哈
      //分区标识
      int i = 0;
      for (NSDictionary *dictSection  in sectionArr) {
          MusicHotModel *modelSection = [MusicHotModel new];
          [modelSection setValuesForKeysWithDictionary:dictSection];
        
          NSArray *rowArr = dictSection[@"data"];
          NSMutableArray *tempArr = [NSMutableArray array];
          for (NSDictionary *dictRow in rowArr) {
              MusicHotModel *modelRow = [MusicHotModel new];
              [modelRow setValuesForKeysWithDictionary:dictRow];
              modelRow.ID = modelRow.action[@"value"];
            
              if(!modelRow.ID) {
                  continue;
              }
              
              if (i == 0) {
                  [_imageURLArr addObject:[NSURL URLWithString:modelRow.pic_url]];
              }
              
              [tempArr addObject:modelRow];
          }
          
          if (tempArr.count > 0) {
              [_dataSourceArray addObject:tempArr];
              [_dataSecion addObject:modelSection];
          }
          i++;
      }
      [self.tableView reloadData];
      [imageBgk removeFromSuperview];
      imageBgk = nil;
  } fail:^{
      
  } view:self.view parameters:nil];
}


@end
