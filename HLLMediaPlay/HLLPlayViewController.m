//
//  HLLPlayViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLPlayViewController.h"
#import "AFURLSessionManager.h"
#import "HLLSearchMediaModel.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVKit/AVKit.h>
#import "MoviePlayerViewController.h"

@interface HLLPlayViewController ()
@property(nonatomic ,strong) AVPlayerViewController * playerViewController;
@end

@implementation HLLPlayViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.link]]];
    [self.view addSubview:webView];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:mediaUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
    
    // Do any additional setup after loading the view.
}
- (void) res{

    
}
- (IBAction)showMediaPlayViewController:(id)sender {
    MoviePlayerViewController *movie = [[MoviePlayerViewController alloc]init];

    [self presentViewController:movie animated:YES completion:^{
        
        
    }];
}
/*
 具体思路是先开始使用request进行下载视频
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
