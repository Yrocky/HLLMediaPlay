//
//  HLLOnlinePlayViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLOnlinePlayViewController.h"
#import "MoviePlayerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HLLMediaInfoModel.h"
#import "HLLMediaModel.h"
#import "PlistHandle.h"
#import "HTTPTool.h"
#import "Masonry.h"


@interface HLLOnlinePlayViewController ()
@property (nonatomic ,strong) HLLMediaInfoModel * mediaInfoModel;
@property (nonatomic ,strong) UIActivityIndicatorView * activity;
@property (nonatomic ,strong) NSURLSessionDownloadTask * downloadTask;

@property (weak, nonatomic) IBOutlet UIView *mediaView;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


@end


@implementation HLLOnlinePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatActivityIndicatorView];
    
    [self currentMediaInfoWithID:self.model.ID];
    
}
- (void)viewDidDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
//    [_downloadTask cancel];
}

- (void) creatActivityIndicatorView{
    
    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [_activity startAnimating];
}

- (IBAction)playMedia:(id)sender {
    
    NSString * playurl;
    NSString * highP = self.mediaInfoModel.playurl[@"720P"];
    NSString * middleP = self.mediaInfoModel.playurl[@"480P"];
    NSString * lowP = self.mediaInfoModel.playurl[@"360P"];
    playurl = highP ? highP:(middleP?middleP:lowP);
    
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:playurl]];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}


// 获取视频的相关内容
- (void) currentMediaInfoWithID:(NSString *)ID{
    
    [HTTPTool requestJXVDYMediaInfoWithID:ID successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"media info result:%@",responseObject);
        _mediaInfoModel = [[HLLMediaInfoModel alloc] initWithDict:responseObject];
        [self playMediaWithSystemMediaFunctionWithResponseObject:responseObject];
//        [self playMediaWithMoviePlayerViewAndDowloadMediaWithResponseObject:responseObject];
        [_activity stopAnimating];
        
    } andFialedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_activity stopAnimating];
        NSLog(@"fail:%@",error.localizedDescription);
    }];
}

// 下载视频
- (void) downloadTaskWithUrlString:(NSString *)urlString fileName:(NSString *)fileName imageUrl:(NSString *)imageUrl description:(NSString *)description ID:(NSString *)ID{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Private_Documents/Cache"];
        NSString * mediaPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
        
        NSDictionary * dict = @{@"ID":ID,
                                @"name":fileName,
                                @"image":imageUrl,
                                @"path":mediaPath,
                                @"description":description};
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:cachePath]){
            
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([fileManager fileExistsAtPath:mediaPath]) {
            return nil;
        }else{
            
            [[PlistHandle sharedPlistHandle] writerDataWithPlistName:@"dowload" ID:ID withDict:dict];
            return [[NSURL alloc] initFileURLWithPath:mediaPath];
        }
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            NSLog(@"error");
        }else{
            NSLog(@"success");
            NSLog(@"File downloaded to: %@", filePath);
        }
        NSLog(@"fileName:%@",fileName);
    }];
    [downloadTask resume];
    _downloadTask = downloadTask;
}

// 使用系统视频播放器播放视频
- (void) playMediaWithSystemMediaFunctionWithResponseObject:(id)responseObject{
    
    self.playButton.enabled = YES;
    [self.playButton setImage:[UIImage imageNamed:@"full_play_btn.png"] forState:UIControlStateNormal];
    
    self.titleLabel.text = self.mediaInfoModel.title;
    self.scoreLabel.text = self.mediaInfoModel.score;
    self.yearLabel.text = self.mediaInfoModel.year;
    self.descriptionLabel.text = self.mediaInfoModel.mediaDescription;
    
    NSArray * types = self.mediaInfoModel.type;
    if (types.count) {
        
        for (NSInteger index = 0; index < types.count; index ++) {
            NSString * type = types[index];
            [self addLabelWithType:type atIndex:index];
        }
    }
    [self.mediaImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img]
                           placeholderImage:[UIImage imageNamed:@"bg_media_default"]];
    
}

- (void) addLabelWithType:(NSString *)type atIndex:(NSInteger)index{

    UILabel * label = [[UILabel alloc] init];
    label.text = type;
    label.tag = index + 100;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = self.scoreLabel.textColor;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 3.0f;
    label.clipsToBounds = YES;
    [self.infoView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(2);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(2);
        if (label.tag == 100) {
            make.left.mas_equalTo(30);
        }else{
            UILabel * forentLabel = [self.infoView viewWithTag:index + 99];
            make.left.mas_equalTo(forentLabel.mas_right).offset(10);
        }
        
    }];
}
// 对获得到的视频内容进行下载和使用moviePlayer控制器的view进行展示
- (void) playMediaWithMoviePlayerViewAndDowloadMediaWithResponseObject:(id)responseObject{

    NSString * playurl;
    NSString * highP = self.mediaInfoModel.playurl[@"720P"];
    NSString * middleP = self.mediaInfoModel.playurl[@"480P"];
    NSString * lowP = self.mediaInfoModel.playurl[@"360P"];
    playurl = highP ? highP:(middleP?middleP:lowP);
    
    [self downloadTaskWithUrlString:playurl
                           fileName:self.model.title
                           imageUrl:self.model.img
                        description:responseObject[@"description"]
                                 ID:self.model.ID];
    
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Private_Documents/Cache"];
    NSString * mediaPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",self.model.title]];
    
    BOOL exist = [[PlistHandle sharedPlistHandle] existMediaFromPlist:@"dowload" WithID:self.model.ID];
    if (exist) {
        
    }
    MoviePlayerViewController * moviePlayerViewController = [[MoviePlayerViewController alloc] init];
    moviePlayerViewController.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 200);
    moviePlayerViewController.mediaInfo = _mediaInfoModel;
    [self.view addSubview:moviePlayerViewController.view];
}
@end
