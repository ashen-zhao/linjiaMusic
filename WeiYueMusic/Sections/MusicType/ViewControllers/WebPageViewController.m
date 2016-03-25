//
//  WebPageViewController.m
//  Shou65
//
//  Created by ashen on 15/6/4.
//  Copyright (c) 2015年 ashen. All rights reserved.
//

#import "WebPageViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
#import "BottomPlayView.h"

#define kMainWidth [UIScreen mainScreen].bounds.size.width
#define kMainHeight [UIScreen mainScreen].bounds.size.height

@interface WebPageViewController ()<UIWebViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) MBProgressHUD *mbHud;
@property (nonatomic, strong) UIWebView *webView ;
@end

@implementation WebPageViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigation.navigationBar.hidden = NO;
    BottomPlayView *bpv = [BottomPlayView shareBottomPlayView];
    [self.view addSubview:bpv];
    [self.view  bringSubviewToFront:bpv];
}


- (void)dealloc {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _mbHud = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    _webView = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在加载中...";
    self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer >= 8.0){
        [self initWKweb];
    } else {
        [self initWVweb];
    }
 
}


#pragma mark - UIWebView 
- (void)initWVweb {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight-64)];
    [_webView setDelegate:self];
    
    NSURL *url = [[NSURL alloc]initWithString:_urlString];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self initMB];
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    [_mbHud removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *tempStr = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (tempStr.length>13) {
        self.title = [[tempStr substringToIndex:12]  stringByAppendingString:@"..."];
    }else{
        self.title = tempStr;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_mbHud removeFromSuperview];
}


#pragma mark - WKWebview 

- (void)initWKweb {
    WKWebView *wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight-64)];
    wk.navigationDelegate = self;
    [wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    [self.view addSubview:wk];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self initMB];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { [_mbHud removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (webView.title.length > 13) {
        self.title = [[webView.title substringToIndex:12]  stringByAppendingString:@"..."];
    }else{
        self.title = webView.title;
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [_mbHud removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Publish Method

- (void)initMB {
    self.mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _mbHud.userInteractionEnabled = NO;
    _mbHud.mode = MBProgressHUDModeIndeterminate;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
