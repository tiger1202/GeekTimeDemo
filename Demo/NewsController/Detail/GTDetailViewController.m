//
//  GTDetailViewController.m
//  Demo
//
//  Created by tiger on 2022/4/28.
//

#import "GTDetailViewController.h"
#import <WebKit/WebKit.h>

@interface GTDetailViewController ()<WKNavigationDelegate>

@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy, readwrite) NSString *articleUrlString;

@end

@implementation GTDetailViewController

- (instancetype)initWithURLString:(NSString *)urlString {
    if (self = [super init]) {
        self.articleUrlString = urlString;
    }
    return self;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:({
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 88)];
        self.webView.navigationDelegate = self;
        self.webView;
    })];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleUrlString]]];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:({
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, 20)];
        self.progressView;
    })];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"加载完毕");
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1.0f) {
            NSLog(@"网页预估加载进度为1，进度条消失");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.progressView removeFromSuperview];
            });
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
