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
#import <AVFoundation/AVFoundation.h>

@interface HLLSettingController ()
@property (nonatomic ,strong) UITableViewCell * selectedCell;
@end

@implementation HLLSettingController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self setupPlayMediaInGPRS];
    
    [self setupMediaTypeAndClearCacheFolder];
}

- (void) setupPlayMediaInGPRS{

    BOOL open = [[NSUserDefaults standardUserDefaults] boolForKey:@"GPRS"];
    UISwitch * GPRSSwitch = [[UISwitch alloc] init];
    GPRSSwitch.on = open;
    [GPRSSwitch addTarget:self action:@selector(GPRSSwitchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    NSIndexPath * GPRSIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell * GPRSCell = [self.tableView cellForRowAtIndexPath:GPRSIndexPath];
    GPRSCell.accessoryView = GPRSSwitch;
}
- (void) setupMediaTypeAndClearCacheFolder{

    // mediaType
    NSString * rowString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mediaType"];
    NSInteger row = [rowString integerValue];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:1];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    _selectedCell = cell;
    
    // clearCacheFolder
    float folderSize = [[FileHandle sharedPlistHandle] getCacheFileSizeAtCachePath];
    if (!folderSize) {
        
        NSIndexPath * clearIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        UITableViewCell * clearCell = [self.tableView cellForRowAtIndexPath:clearIndexPath];
        clearCell.selectionStyle = UITableViewCellSelectionStyleNone;
        clearCell.textLabel.textColor = [UIColor lightGrayColor];
    }
}

- (void) GPRSSwitchDidChangeValue:(UISwitch *)GPRSSwitch{

    [[NSUserDefaults standardUserDefaults] setBool:GPRSSwitch.on forKey:@"GPRS"];
}
- (void) clearCacheMediaWithIndexPath:(NSIndexPath *)indexPath{

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要清空缓存视频么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 删除plist文件
        [[PlistHandle sharedPlistHandle] clearDataWithPlistName:@"dowload"];
        
        // 删除放视频的文件夹
        [[FileHandle sharedPlistHandle] clearMediaCacheFolder];
        
        // 将cell置为不能选
        UITableViewCell * clearCell = [self.tableView cellForRowAtIndexPath:indexPath];
        clearCell.selectionStyle = UITableViewCellSelectionStyleNone;
        clearCell.textLabel.textColor = [UIColor lightGrayColor];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (_selectedCell != cell) {
            _selectedCell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _selectedCell = cell;
        }
        NSString * rowString = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:rowString forKey:@"mediaType"];
    }
    if(indexPath.section == 2 && indexPath.row == 0 && [[FileHandle sharedPlistHandle] getCacheFileSizeAtCachePath]){
        [self clearCacheMediaWithIndexPath:indexPath];
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
