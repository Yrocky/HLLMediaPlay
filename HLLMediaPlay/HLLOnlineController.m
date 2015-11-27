//
//  HLLOnlineController.m
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLOnlineController.h"
#import "HLLOnlinePlayViewController.h"
#import "MJRefreshBackNormalFooter.h"
#import "MoviePlayerViewController.h"
#import "HLLPlayerController.h"
#import "HLLMediaModel.h"
#import "HLLOnlineCell.h"
#import "HTTPTool.h"

@interface HLLOnlineController ()<UISearchBarDelegate>
@property (nonatomic ,strong) NSMutableArray * onlineMedias;
@property (nonatomic ,assign) int offset;
@end

@implementation HLLOnlineController

- (NSMutableArray *)onlineMedias{

    if (_onlineMedias == nil) {
        _onlineMedias = [NSMutableArray array];
    }
    return _onlineMedias;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * keyword = @"恐怖故事";
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    [self searchKeyword:keyword loadMore:NO];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString * identifier = segue.identifier;
    if ([identifier isEqualToString:@"onlinePlay"]) {
        HLLOnlinePlayViewController * playViewController = segue.destinationViewController;
        playViewController.model = sender;
    }
    if ([identifier isEqualToString:@"customPlay"]) {
        HLLPlayerController * playerController = segue.destinationViewController;
        playerController.mediaID = sender;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.onlineMedias.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLLOnlineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"online" forIndexPath:indexPath];
    
    HLLMediaModel * model = self.onlineMedias[indexPath.row];
    [cell configureCellWithMediaModel:model];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HLLMediaModel * model = self.onlineMedias[indexPath.row];

    
    UIAlertController * actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * customAction = [UIAlertAction actionWithTitle:@"使用自定义播放器进行播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self performSegueWithIdentifier:@"customPlay" sender:[NSString stringWithFormat:@"%@",model.ID]];
    }];
    UIAlertAction * systemAction = [UIAlertAction actionWithTitle:@"使用系统播放器进行播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self performSegueWithIdentifier:@"onlinePlay" sender:model];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:systemAction];
    [actionSheetController addAction:customAction];
//    [self.tabBarController presentViewController:actionSheetController animated:YES completion:nil];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    NSString * searchInfo = searchBar.text;
    
    [self.onlineMedias removeAllObjects];
    [self.tableView reloadData];
    
    [self searchKeyword:searchInfo loadMore:NO];
}
- (void) loadMoreData{
    NSString * keyword = @"恐怖故事";
    [self searchKeyword:keyword loadMore:YES];
}
- (void) searchKeyword:(NSString *)keyWord loadMore:(BOOL)loadMore{
    
    if (loadMore) {
        _offset++;
    }
    NSString * offset = [NSString stringWithFormat:@"%d",_offset];
    
    [HTTPTool requestJXVDYMediaSourceWithKeyword:keyWord offset:offset successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"result:%@",responseObject);
        for (NSDictionary *dict in responseObject) {
            HLLMediaModel * model = [[HLLMediaModel alloc] initWithDict:dict];
            [self.onlineMedias addObject:model];
        }
        [self.tableView reloadData];
    } andFialedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"fail:%@",error.localizedDescription);
    }];
}

@end
