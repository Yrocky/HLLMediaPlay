//
//  ViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "HLLSearchMediaModel.h"
#import "HLLDowloadCell.h"
#import "PlistHandle.h"
#import "FileHandle.h"
#import "HTTPTool.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray * medias;
@end

@implementation ViewController

- (NSMutableArray *)medias{

    if (_medias == nil) {
        _medias = [NSMutableArray array];
    }
    return _medias;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[HLLDowloadCell nib] forCellReuseIdentifier:[HLLDowloadCell identifier]];
    
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSArray * medias = [[PlistHandle sharedPlistHandle] getDataWithPlistName:@"dowload"];
    
    [self.medias removeAllObjects];
    for (NSDictionary * media in medias) {
        
        HLLDowloadModel * model = [[HLLDowloadModel alloc] initWithDict:media];
        [self.medias addObject:model];
    }
    
    [self.tableView reloadData];

    [self barButtonItemEnabledHandle];
}
- (void) barButtonItemEnabledHandle{

    if (self.medias.count) {
        self.tableView.hidden = NO;
        self.editBarButtonItem.enabled = YES;
    }else{
        self.tableView.hidden = YES;
        [self.tableView setEditing:NO animated:YES];
        self.editBarButtonItem.enabled = NO;
    }
}
- (IBAction)mainViewContoller_ClearMediaData:(id)sender {
    
    [self performSegueWithIdentifier:@"setting" sender:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
- (IBAction)mainViewController_EditMedia:(id)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLLDowloadCell * cell = [tableView dequeueReusableCellWithIdentifier:[HLLDowloadCell identifier] forIndexPath:indexPath];
    
    HLLDowloadModel * model = self.medias[indexPath.row];
    [cell configureCellWithModel:model];
    
    return cell;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.medias.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HLLDowloadModel * model = self.medias[indexPath.row];
        
        // 删除plist文件中的视频缓存记录
        [[PlistHandle sharedPlistHandle] removeDataWithPlistName:@"dowload" withDataID:[NSString stringWithFormat:@"%@",model.ID]];
        [self.medias removeObject:model];
        
        // 删除本地缓存的视频
        [[FileHandle sharedPlistHandle] removeMediaCacheFileWithFileName:model.name];
    }
    [tableView reloadData];

    [self barButtonItemEnabledHandle];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

    return @"删除";
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 88.0f;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HLLDowloadModel * model = self.medias[indexPath.row];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString * mediaPath = [[FileHandle sharedPlistHandle] getMediaPathWithFileName:model.name];
    NSURL * mediaUrl = [[FileHandle sharedPlistHandle] getMediaUrlWithMediaName:model.name];

    if ([fileManager fileExistsAtPath:mediaPath]) {
        
        AVPlayer * player = [AVPlayer playerWithURL:mediaUrl];
        AVPlayerViewController * playerViewConteller = [[AVPlayerViewController alloc] init];
        playerViewConteller.player = player;
        [self presentViewController:playerViewConteller animated:YES completion:^{
        
            [player play];
        }];
    }else{
        NSLog(@"Hei man ,you cant be here!!");
    }
    
    
}

@end
