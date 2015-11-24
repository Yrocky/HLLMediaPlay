//
//  ViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "HTTPTool.h"
#import "HLLSearchMediaModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
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

    self.tableView.hidden = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    NSURL * url  = [NSURL URLWithString:@"http://objccn.io/content/images/2014/Dec/6746362.png"];
    [self.image sd_setImageWithURL:url];
}
- (IBAction)mainViewContoller_ShowDediaData:(id)sender {
    
    [self.medias addObject:@"as"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.medias.count;
}
#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"选择一个本地视频播放");
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    
}

@end
