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

#import "HLLPlayerController.h"

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

    
    [self sfdsgWithID:model.ID];
    
    return;
    MoviePlayerViewController * moviePlayerController = [[MoviePlayerViewController alloc] init];
//    moviePlayerController.mediaInfo = 
//    HLLPlayerController * playerController = [[HLLPlayerController alloc] init];
//    playerController.Hls_url = model.ID;
    [self.navigationController pushViewController:moviePlayerController animated:YES];
//    [self performSegueWithIdentifier:@"onlinePlay" sender:model];
}

- (void) sfdsgWithID:(NSString *)ID{

    [HTTPTool requestJXVDYMediaInfoWithID:ID successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"media info result:%@",responseObject);

        NSString * hls_url;

        NSString * highP = responseObject[@"playurl"][@"720P"];
        NSString * middleP = responseObject[@"playurl"][@"480P"];
        NSString * lowP = responseObject[@"playurl"][@"360P"];
        hls_url = highP ? highP:(middleP?middleP:lowP);

        HLLPlayerController * playerController = [[HLLPlayerController alloc] init];
        playerController.Hls_url = hls_url;
        [self.navigationController pushViewController:playerController animated:YES];
        
    } andFialedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"fail:%@",error.localizedDescription);
    }];
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
