//
//  HLLSearchController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLSearchController.h"
#import "HLLSearchMediaModel.h"
#import "HLLSearchCell.h"
#import "HTTPTool.h"
#import "HLLPlayViewController.h"
#import "MJExtension.h"
#import "HLLMediaModel.h"

@interface HLLSearchController ()<UISearchBarDelegate>

@property (nonatomic ,strong) NSMutableArray * searchResuletMArray;
@end

@implementation HLLSearchController

-(NSMutableArray *)searchResuletMArray{

    if (_searchResuletMArray == nil) {
        _searchResuletMArray = [NSMutableArray array];
    }
    return _searchResuletMArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchKeyword:@"旅游宣传片"];
    
//    [self.tableView registerClass:[HLLSearchCell class] forCellReuseIdentifier:@"search"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    NSString * identifier = segue.identifier;
    if ([identifier isEqualToString:@"play"]) {
        HLLPlayViewController * playViewController = segue.destinationViewController;
        playViewController.model = sender;
    }
}
#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HLLSearchMediaModel * model = self.searchResuletMArray[indexPath.row];
    [self performSegueWithIdentifier:@"play" sender:model];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchResuletMArray.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLLSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"search" forIndexPath:indexPath];
    
    HLLSearchMediaModel * model = self.searchResuletMArray[indexPath.row];
    [cell configureCellWithModel:model];
    
    return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self.view endEditing:YES];
    NSString * searchInfo = searchBar.text;
    
    [self.searchResuletMArray removeAllObjects];
    [self.tableView reloadData];
    
    [self searchKeyword:searchInfo];
}

#pragma mark - action
- (IBAction)searchMediaInfoWithKeyword:(UIBarButtonItem *)sender {
    
    [self searchKeyword:@"NBA"];
}

- (void) searchKeyword:(NSString *)keyWord{
    
    [HTTPTool requestSearchMediaInfoWithKeyWord:keyWord successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"result:%@",responseObject);
        NSArray * videos = [responseObject valueForKey:@"videos"];
        for (NSDictionary * video in videos) {
            HLLSearchMediaModel * model = [HLLSearchMediaModel mediaModelWithDictionary:video];
            [self.searchResuletMArray addObject:model];
        }
        [self.tableView reloadData];
    } andFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fail:%@",error.localizedDescription);
    }];
    
}



- (IBAction)clearSearchMediaData:(id)sender {
    
    [self.searchResuletMArray removeAllObjects];
    [self.tableView reloadData];
}

@end
