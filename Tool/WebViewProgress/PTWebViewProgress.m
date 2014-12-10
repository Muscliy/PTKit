//
//  PTWebViewProgress.m
//  xmLife
//
//  Created by LeeHu on 14/12/8.
//  Copyright (c) 2014年 PaiTao. All rights reserved.
//

#import "PTWebViewProgress.h"

NSString *completeRPCURL = @"webviewprogressproxy:///complete";

const float PTInitialProgressValue = 0.1f;
const float PTInteractiveProgressValue = 0.7f;
const float PTFinalProgressValue = 0.9f;

@interface PTWebViewProgress () {
    NSURL *_currentURL;
    BOOL _interactive;
}

@end

@implementation PTWebViewProgress

- (instancetype)init
{
    if ((self = [super init])) {
        _interactive = NO;
    }
    return self;
}

- (void)setProgress:(float)progress
{
    if ([_progressDelegate respondsToSelector:@selector(webViewProgress:updatePogress:)]) {
        [_progressDelegate webViewProgress:self updatePogress:progress];
    }
    if (_progressBlock) {
        _progressBlock(progress);
    }
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)incrementProgress
{
    [self setProgress:PTFinalProgressValue];
}

- (void)reset
{
    _interactive = NO;
    [self setProgress:0.0];
}

//------------------------

#pragma mark - UIWebViewDelegate

//------------------------

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType
{

    if ([request.URL.absoluteString isEqualToString:completeRPCURL]) {
        [self completeProgress];
        return NO;
    }

    BOOL ret = YES;
    if ([self.webViewDelegate
            respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [self.webViewDelegate webView:webView
                 shouldStartLoadWithRequest:request
                             navigationType:navigationType];
    }

    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString
            stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment]
                                      withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }

    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];

    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] ||
                  [request.URL.scheme isEqualToString:@"https"];
    if (ret && !isFragmentJump && isHTTP && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
        [self setProgress:PTInitialProgressValue];
    }

    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }

    [self setProgress:PTInteractiveProgressValue];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }

    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString
            stringWithFormat:@"window.addEventListener('load',function() { var iframe = "
                             @"document.createElement('iframe'); iframe.style.display = 'none'; "
                             @"iframe.src = '%@'; document.body.appendChild(iframe);  }, false);",
                             completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }

    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:webView didFailLoadWithError:error];
    }
    [self webViewDidFinishLoad:webView];
}

@end
