//
//  PTWebViewController.m
//  PTKit
//
//  Created by LeeHu on 9/13/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTWebViewController.h"

@interface PTWebViewController ()

@property (nonatomic, strong) NSURL* loadingURL;

@property (nonatomic, strong) NSURLRequest* loadRequest;

@property (nonatomic, strong) UIWebView* webView;

@end

@implementation PTWebViewController

- (id)initWithRequest:(NSURLRequest *)request {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.hidesBottomBarWhenPushed = YES;
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        [self openRequest:request];
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL {
    return [self initWithRequest:[NSURLRequest requestWithURL:URL]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithRequest:nil];
}

- (NSURL *)URL {
    return self.loadingURL ? self.loadingURL : self.webView.request.mainDocumentURL;
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}

- (void)openRequest:(NSURLRequest *)request {
    self.loadRequest = request;
    
    if ([self isViewLoaded]) {
        if (nil != request) {
            [self.webView loadRequest:request];
            
        } else {
            [self.webView stopLoading];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self openURL:[NSURL URLWithString:@"http://192.168.4.130:8080/?qrcode=ABbMjm"]];
}

- (void)loadView {
    [super loadView];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark - UIWebView

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    self.loadingURL = nil;
    [self webViewDidFinishLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    self.loadingURL = nil;
}

@end
