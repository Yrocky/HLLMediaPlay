//
//  HLLWebViewController.m
//  HLLMediaPlay
//
//  Created by admin on 15/12/30.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface HLLWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HLLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHTMLString];
    JSContext * yArray  = [[JSContext alloc] init];
    [yArray evaluateScript:@"var array = [20,'Hello world!'];"];
    JSValue * yValue = yArray[@"array"];
    NSLog(@"%@,%@",yValue,[yValue toArray]);

    loadJavaScript(yArray,@"main.js");

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
//    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alertJS=@"alert('test js to OC')"; //准备执行的js代码
//    [context evaluateScript:alertJS];//通过oc方法调用js的alert
//    
}
/**
 *  加载js文件
 *
 *  @param context  JSContext
 *  @param fileName js文件名
 */
void loadJavaScript(JSContext * context ,NSString * fileName){

    NSString * filePath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],fileName];
    NSString * script = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
    [context evaluateScript:script];
};

- (void) loadHTMLString{
    
    NSString * path = [[NSBundle mainBundle] bundlePath];
    NSURL * baseURL = [NSURL fileURLWithPath:path];
    NSArray * htmlName = @[@"chart"];
    NSString * html = htmlName[0];
    NSString * htmlPath    = [[NSBundle mainBundle] pathForResource:html
                                                             ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [self.webView loadHTMLString:htmlContent baseURL:baseURL];
}

@end
