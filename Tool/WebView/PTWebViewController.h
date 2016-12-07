//
//  PTWebViewController.h
//  PTKit
//
//  Created by LeeHu on 9/13/16.
//  Copyright © 2016 LeeHu. All rights reserved.
//

#import "PTBaseViewCotroller.h"

@interface PTWebViewController : PTBaseViewCotroller<UIWebViewDelegate>

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithURL:(NSURL *)URL;

- (NSURL *)URL;

- (void)openURL:(NSURL*)URL;
- (void)openRequest:(NSURLRequest*)request;
- (void)openHTMLString:(NSString*)htmlString baseURL:(NSURL*)baseUrl;


@property (nonatomic, readonly, strong) UIWebView* webView;

@end
