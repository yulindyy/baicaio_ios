
//
//  GoLinkWebViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/5/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "GoLinkWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface GoLinkWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>


@end

@implementation GoLinkWebViewController{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSInteger timerRunNum;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timerRunNum = 5;
//    _progressProxy = [[NJKWebViewProgress alloc] init];
//    _webView.delegate = _progressProxy;
//    _progressProxy.webViewProxyDelegate = self;
//    _progressProxy.progressDelegate = self;
//    
//    CGFloat progressBarHeight = 2.f;
//    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
//    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
//    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]];
    
       
    //NSString *taobao_reg = @"taobao.com";
   // NSPredicate * taobao_predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", taobao_reg];
   // BOOL isValid =  [taobao_predicate evaluateWithObject:self.webUrl];
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(@"taobao://s.click.taobao.com/t?e=m%3D2%26s%3DhLXt8BlJAqUcQipKwQzePOeEDrYVVa64K7Vc7tFgwiHjf2vlNIV67pnL%2BP2Kc99%2BdgpT%2Fnt4ZAiTdiKqRJn2UESQZ4SJ7WOUI0U7s9XZrVkVU6cQSWsk%2FVAKmgonBT%2BWeKyRIFSnZCjgticMFOHQdOwolw8QIGb%2FPuUKMILxyTw%3D&pvid=10_118.250.181.172_604_1507698320886")]];
    [self.myWebView loadRequest:request];
    self.myWebView.delegate = self;//_progressProxy;
    NSLog(@"=======++++++");
    NSTimer *timer = [NSTimer timerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"xxxxxxxxxxxxxxxxxxxxxxx");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        timerRunNum -- ;
        if (timerRunNum == 0) {
            [timer invalidate];
            timer = nil;
        }


    }];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([MBProgressHUD allHUDsForView:self.view].count == 0) {
        [MBProgressHUD showMessag:@"加载中..." toView:self.view];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
        [self.view addSubview:HUD];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    if (self.myWebView.isLoading) {
        return;
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if (self.myWebView.isLoading) {
        return;
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
