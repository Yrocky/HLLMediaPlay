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
#import "HTTPTool.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
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
        self.trashBarButtonItem.enabled = self.editBarButtonItem.enabled = YES;
    }else{
        self.tableView.hidden = YES;
        [self.tableView setEditing:NO animated:YES];
        self.trashBarButtonItem.enabled = self.editBarButtonItem.enabled = NO;
    }
}
- (IBAction)mainViewContoller_ClearMediaData:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定要清空缓存视频么" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (NSInteger index; index < self.medias.count; index ++) {

            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self tableView:self.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];

    [self presentViewController:alertController animated:YES completion:nil];
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
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSString * path = [NSString stringWithFormat:@"%@/%@",documentsDirectoryURL,model.path];
        BOOL removeResult = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        [[PlistHandle sharedPlistHandle] removeDataWithPlistName:@"dowload" withDataID:[NSString stringWithFormat:@"%@",model.ID]];
        [self.medias removeObject:model];
        NSLog(@"%d",removeResult);
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
    
    NSString * docmentUrl = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSString * path = [NSString stringWithFormat:@"%@/%@",docmentUrl,model.path];
    NSURL * url = [NSURL URLWithString:path];
    
    AVPlayerViewController * playerViewController = [[AVPlayerViewController alloc] init];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:url];
    AVPlayer * player = [AVPlayer playerWithPlayerItem:playerItem];
    playerViewController.player = player;
    [self presentViewController:playerViewController animated:YES completion:nil];
}

@end
