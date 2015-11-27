//
//  HLLSettingController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/27.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLSettingController.h"
#import "FileHandle.h"
#import "PlistHandle.h"


@interface HLLSettingController ()

@end

@implementation HLLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) clearCacheMedia{

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要清空缓存视频么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 删除plist文件
        [[PlistHandle sharedPlistHandle] clearDataWithPlistName:@"dowload"];
        
        // 删除放视频的文件夹
        [[FileHandle sharedPlistHandle] clearMediaCacheFolder];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
    }
    if(indexPath.section == 2 && indexPath.row == 0){
        [self clearCacheMedia];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
