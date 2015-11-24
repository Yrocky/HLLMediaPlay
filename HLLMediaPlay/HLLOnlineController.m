//
//  HLLOnlineController.m
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLOnlineController.h"
#import "HLLMediaModel.h"
#import "HLLOnlineCell.h"
#import "HLLPlayViewController.h"



@interface HLLOnlineController ()
@property (nonatomic ,strong) NSMutableArray * onlineMedias;

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
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"mediaSource" ofType:@"json"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray * medias = [dict objectForKey:@"Data"];
    for (NSDictionary * media in medias) {
        HLLMediaModel * model = [[HLLMediaModel alloc] init];
        [model setValuesForKeysWithDictionary:media];
        [self.onlineMedias addObject:model];
    }
    [self.tableView reloadData];
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


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    HLLSearchMediaModel * model = self.searchResuletMArray[indexPath.row];
    HLLMediaModel * model = self.onlineMedias[indexPath.row];
    [self performSegueWithIdentifier:@"play" sender:model];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
