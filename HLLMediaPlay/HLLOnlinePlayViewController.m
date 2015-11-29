//
//  HLLOnlinePlayViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLOnlinePlayViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AVKit/AVKit.h>

#import "MoviePlayerViewController.h"
#import "HLLMediaInfoModel.h"
#import "HLLMediaModel.h"
#import "PlistHandle.h"
#import "FileHandle.h"
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
    
    AFNetworkReachabilityManager * networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    
    [self creatActivityIndicatorView];
    
    [self currentMediaInfoWithID:self.model.ID];
    
}
- (void)dealloc{

    AFNetworkReachabilityManager * networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager stopMonitoring];
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    if (_downloadTask) {

        [_downloadTask cancel];
    }
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
    
    AFNetworkReachabilityManager * networkManager = [AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
    BOOL wwan = networkManager.isReachableViaWWAN;
    NSString * status = [networkManager localizedNetworkReachabilityStatusString];
    NSLog(@"status:%@",status);
    if (wwan) {
        
        BOOL open = [[NSUserDefaults standardUserDefaults] boolForKey:@"GPRS"];
        if (!open) {            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"当前使用蜂窝移动网络，继续观看可能会产生大量的流量，是否继续？您可以到\"设置->蜂窝移动网络播放\"进行设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self playerMedia];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:sureAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else{
    
        [self playerMedia];
    }
    
}

// 播放视频
- (void) playerMedia{

    NSString * playPath;
    NSURL * playUrl;
    NSString * highP = self.mediaInfoModel.playurl[@"720P"];
    NSString * middleP = self.mediaInfoModel.playurl[@"480P"];
    NSString * lowP = self.mediaInfoModel.playurl[@"360P"];
    
    NSString * rowString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mediaType"];
    NSInteger row = [rowString integerValue];
    if (row) {
        if (row == 1) {// middle
            playPath = (middleP?middleP:lowP);
        }else{// low
            playPath = lowP;
        }
    }else{//  high
        playPath = highP ? highP:(middleP?middleP:lowP);
    }
    
    BOOL exist = [[PlistHandle sharedPlistHandle] existMediaFromPlist:@"dowload" WithID:[NSString stringWithFormat:@"%@",self.model.ID]];
    
    if (exist) {
        // 播放本地视频
        playPath = [[FileHandle sharedPlistHandle] getMediaPathWithFileName:self.model.title];
        playUrl = [NSURL fileURLWithPath:playPath];
    }else{
        // 从网络缓存到本地
        [self downloadTaskWithUrlString:playPath
                               fileName:self.model.title
                               imageUrl:self.model.img
                            description:self.mediaInfoModel.mediaDescription
                                     ID:self.model.ID];
        playUrl = [NSURL URLWithString:playPath];
    }
    
    AVPlayer * player = [AVPlayer playerWithURL:playUrl];
    AVPlayerViewController * playerViewConteller = [[AVPlayerViewController alloc] init];
    playerViewConteller.player = player;
    [self presentViewController:playerViewConteller animated:YES completion:^{
        [player play];
    }];
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
        
        NSString *cachePath = [[FileHandle sharedPlistHandle] getMediaCachePath];
        NSString * mediaPath = [[FileHandle sharedPlistHandle] getMediaPathWithFileName:fileName];
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
            return [NSURL fileURLWithPath:mediaPath];
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
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.mediaInfoModel.title];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@",self.mediaInfoModel.score];
    self.yearLabel.text = [NSString stringWithFormat:@"%@",self.mediaInfoModel.year];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@",self.mediaInfoModel.mediaDescription];
    
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

    NSString * playPath;
    NSURL * playUrl;
    NSString * highP = self.mediaInfoModel.playurl[@"720P"];
    NSString * middleP = self.mediaInfoModel.playurl[@"480P"];
    NSString * lowP = self.mediaInfoModel.playurl[@"360P"];
    
    NSString * rowString = [[NSUserDefaults standardUserDefaults] objectForKey:@"mediaType"];
    NSInteger row = [rowString integerValue];
    if (row) {
        if (row == 1) {// middle
            playPath = (middleP?middleP:lowP);
        }else{// low
            playPath = lowP;
        }
    }else{//  high
        playPath = highP ? highP:(middleP?middleP:lowP);
    }
    
    
    [self downloadTaskWithUrlString:playPath
                           fileName:self.model.title
                           imageUrl:self.model.img
                        description:responseObject[@"description"]
                                 ID:self.model.ID];
    
    BOOL exist = [[PlistHandle sharedPlistHandle] existMediaFromPlist:@"dowload" WithID:self.model.ID];
    if (exist) {
        
    }
    MoviePlayerViewController * moviePlayerViewController = [[MoviePlayerViewController alloc] init];
    moviePlayerViewController.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 200);
    moviePlayerViewController.mediaInfo = _mediaInfoModel;
    [self.view addSubview:moviePlayerViewController.view];
}
@end
