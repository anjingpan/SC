//
//  AJNewsViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/28.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewsViewController.h"
#import <WebKit/WebKit.h>

static NSString *const kEstimatedProgress = @"estimatedProgress";   /**< 网页加载进度Key*/
static NSString *const kTitle = @"title";                           /**< 网页标题 key*/

@interface AJNewsViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;               /**< 网页视图*/
@property (nonatomic, strong) UIBarButtonItem *backItem;        /**< 网页返回按钮*/
@property (nonatomic, strong) UIBarButtonItem *closeItem;       /**< 网页关闭按钮*/
@property (nonatomic, strong) UIProgressView *processView;      /**< 进度条*/

@end

@implementation AJNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //ios9以上不支持非 https 请求,支持 http 需要在 info.plist 中添加 Allow Arbitrary Loads 为 Yes
    self.urlString = @"https://www.baidu.com";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:kEstimatedProgress];
    [self.webView removeObserver:self forKeyPath:kTitle];
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
        
        webView.navigationDelegate = self;
        //观察网页加载进度
        [webView addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew context:nil];
        //观察网页标题
        [webView addObserver:self forKeyPath:kTitle options:NSKeyValueObservingOptionNew context:nil];
        
        [self.view addSubview:webView];
        webView;
    });
    
    self.backItem = ({
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 44, 44);
        //按钮前移，否则前面会有空缺
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [button setImage:[UIImage imageNamed:@"School_Back"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
        
        barItem.customView = button;
        barItem;
    });
    
    self.closeItem = ({

        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeToViewController)];
        barItem;
    });
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    self.processView = ({
        UIProgressView *processView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, 2)];
        processView.tintColor = [UIColor greenColor];
        [self.view addSubview:processView];
        processView;
    });
}

#pragma mark - Button Click
//返回上一页面
- (void)backToFront{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self closeToViewController];
    }
}

//关闭 webView
- (void)closeToViewController{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - MKNavigation Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.processView.hidden = false;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //加载网页失败隐藏进度条
    self.processView.hidden = true;
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    if ([webView canGoBack]) {
//        self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
//    }else{
//        self.navigationItem.leftBarButtonItem = self.backItem;
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
    }else{
        self.navigationItem.leftBarButtonItem = self.backItem;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:kEstimatedProgress]) {
        self.processView.progress = self.webView.estimatedProgress;
        
        if (self.processView.progress == 1) {
            self.processView.hidden = true;
        }
    
    }
    
    if ([keyPath isEqualToString:kTitle]) {
        self.title = self.webView.title;
    }
}

@end
