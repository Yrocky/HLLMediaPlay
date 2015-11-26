//
//  HLLOnlinePlayViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLOnlinePlayViewController.h"
#import "MoviePlayerViewController.h"
#import "HLLMediaInfoModel.h"
#import "HLLMediaModel.h"
#import "PlistHandle.h"
#import "HTTPTool.h"
#import "Masonry.h"


@interface HLLOnlinePlayViewController ()
@property (nonatomic ,strong) HLLMediaInfoModel * mediaInfoModel;
@property (nonatomic ,strong) UIActivityIndicatorView * activity;
@property (nonatomic ,strong) NSURLSessionDownloadTask * downloadTask;
@end


@implementation HLLOnlinePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLSession * session = [NSURLSession sharedSession];
    [session invalidateAndCancel];
    
    [self currentMediaInfoWithID:self.model.ID];
    
}
- (void)viewDidDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [_downloadTask cancel];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) creatActivityIndicatorView{
    
    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [_activity startAnimating];
}
 
- (void) currentMediaInfoWithID:(NSString *)ID{

    [HTTPTool requestJXVDYMediaInfoWithID:ID successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"media info result:%@",responseObject);
        _mediaInfoModel = [[HLLMediaInfoModel alloc] initWithDict:responseObject];
        
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
//        [moviePlayerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.top.mas_equalTo(64);
////            make.height.mas_equalTo(200);
//            make.bottom.mas_equalTo(0);
//        }];
        [_activity stopAnimating];
        
    } andFialedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_activity stopAnimating];
        NSLog(@"fail:%@",error.localizedDescription);
    }];
}

@end
