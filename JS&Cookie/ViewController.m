//
//  ViewController.m
//  JS&Cookie
//
//  Created by 雷王 on 2017/12/14.
//  Copyright © 2017年 WL. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
}
- (void)createUI{
    self.webView=[[UIWebView alloc] init];
    self.webView.frame=self.view.bounds;
    self.webView.scalesPageToFit=YES;
    self.webView.delegate=self;
    NSURL *Url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:Url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}
#pragma mark -- 获取cookie
- (void)getCookie:(NSURL *)url
{
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cachCookies = [cookieJar cookiesForURL:url];

    NSMutableString *cookieString = [[NSMutableString alloc] init];
    for (NSHTTPCookie*cookiew in [cookieJar cookies]) {
        [cookieString appendFormat:@"%@=%@;",cookiew.name,cookiew.value];
    }
    NSString *str=cookieString;
}

#pragma mark -- 清楚cookie
- (void)clearCookie:(NSURL *)url
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    //清除所有cookie
    NSArray *cachCookies = [cookieStorage cookiesForURL:url];
    for (int i = 0; i < [cachCookies count]; i++) {
        NSHTTPCookie *cookie = (NSHTTPCookie *)[cachCookies objectAtIndex:i];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}
#pragma mark --UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    JSContext *contentJS = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self)weakSelf =self;
    contentJS[@"console"][@"log"] = ^(JSValue * msg) {
        JSValue *jsValue= msg;
        NSString *str = [jsValue toString];
       
        NSLog(@"H5  log : %@", msg);
    };
    contentJS[@"console"][@"warn"] = ^(JSValue * msg) {
        NSLog(@"H5  warn : %@", msg);
    };
    contentJS[@"console"][@"error"] = ^(JSValue * msg) {
        NSLog(@"H5  error : %@", msg);
    };
    contentJS[@"Function"] = ^() {
        
        NSArray *thisArr = [JSContext currentArguments];
        
        for (JSValue *jsValue in thisArr) {
            
            NSLog(@"=======%@",jsValue);
            
        }
        //
        //        //JSValue *this = [JSContext currentThis];
        //
        //        //NSLog(@"this: %@",this);
        //
        NSLog(@"js调用oc---------The End-------");
    };
    
    
    NSLog(@"webViewDidFinishLoad");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
