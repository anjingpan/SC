//
//  AJNewsViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/28.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewsViewController.h"
#import <WebKit/WebKit.h>

@interface AJNewsViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation AJNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //ios9以上不支持非 https 请求
    self.urlString = @"https://www.baidu.com";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initView{
    self.webView = ({
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = true;
        config.preferences.javaScriptCanOpenWindowsAutomatically = false;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
        
        [self.view addSubview:webView];
        webView;
    });
}

@end
