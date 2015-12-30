//
//  HLLPlayViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLPlayViewController.h"
#import "HLLSearchMediaModel.h"
#import "TFHpple.h"
#import "HTTPTool.h"
#import "Masonry.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@interface HLLPlayViewController ()
@end

@implementation HLLPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView * webView = [[UIWebView alloc] init];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.model.link]]];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        NSLog(@"9.0");
    }
    if (iOS8) {
        NSLog(@"iOS8");
    }
    NSData * htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.link]];
    TFHpple * docment = [[TFHpple alloc] initWithHTMLData:htmlData];
//    TFHppleElement * element = [elements objectAtIndex:0];
    TFHppleElement * element = [docment peekAtSearchWithXPathQuery:@"player"];
    NSLog(@"element:%@",element);
//    张澜&bankcardno=6214850101566983
    NSString *httpUrl = @"http://apis.baidu.com/datatiny/cardinfo/cardinfo";
    NSString *httpArg = @"cardnum=6214850101566983";
    [self request: httpUrl withHttpArg: httpArg];

}

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"8a0f0d6d9236a7135477e1fc2e744ef3" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   NSLog(@"HttpResponseBody %@",responseString);
                               }
                           }];
}


- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
} //当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
