//
//  HLLPlayViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLPlayViewController.h"
#import "HLLSearchMediaModel.h"

@interface HLLPlayViewController ()
@end

@implementation HLLPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.model.link]]];
    [self.view addSubview:webView];
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
