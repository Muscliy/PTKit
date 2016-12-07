//
//  PTSearchNavigatonBar.m
//  PTKit
//
//  Created by LeeHu on 9/21/15.
//  Copyright © 2015 LeeHu. All rights reserved.
//

#import "PTSearchNavigatonBar.h"
#import "PTLogger.h"
#import "UIControl+Extents.h"

#define MARGIN 10

@interface PTSearchNavigatonBar () <UISearchBarDelegate> {
    struct {
        int isImplementSearchCanceled : 1;
        int isImplementSearchBarTextChanged : 1;
        int isImplementSearchBarBegin : 1;
        int isImplementSearchText : 1;

    } _delegateRespondsTo;
}

@end

@implementation PTSearchNavigatonBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if ((self = [super init])) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initSubViews];
    }
    return self;
}

#pragma mark -
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_searchBar) {
        _searchBar.placeholder = placeholder;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    if (_searchBar) {
        _searchBar.text = text;
    }
}

- (void)setDelegate:(id<PTSearchNavigationBarDelegate>)delegate
{
    _delegate = delegate;

    if (![delegate respondsToSelector:@selector(searchBar:searchCanceled:)]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"searchBar:searchCanceled: unimplemented by data source"];
    }

    if (![delegate respondsToSelector:@selector(searchBar:textChanged:)]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"searchBar:textChanged: unimplemented by data source"];
    }

    _delegateRespondsTo.isImplementSearchBarBegin =
        [delegate respondsToSelector:@selector(searchBar:beginSearch:)];
    _delegateRespondsTo.isImplementSearchBarTextChanged =
        [delegate respondsToSelector:@selector(searchBar:textChanged:)];
    _delegateRespondsTo.isImplementSearchCanceled =
        [delegate respondsToSelector:@selector(searchBar:searchCanceled:)];
    _delegateRespondsTo.isImplementSearchText =
        [delegate respondsToSelector:@selector(searchBar:searchText:)];
}

- (BOOL)becomeFirstResponder
{
    [_searchBar becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - view method
- (void)initSubViews
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    [_searchBar.layer setMasksToBounds:YES];

    //左边和右边的图 需要等到 icon 出来再改
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_1) {
            [[[[_searchBar.subviews firstObject] subviews] firstObject] removeFromSuperview];
            [_searchBar setBackgroundColor:[UIColor clearColor]];
        } else {
            // iOS7.0
            [_searchBar setBarTintColor:[UIColor clearColor]];
            [_searchBar setBackgroundColor:[UIColor clearColor]];
        }
    } else {
        // iOS7.0以下
        [[_searchBar.subviews firstObject] removeFromSuperview];
        [_searchBar setBackgroundColor:[UIColor clearColor]];
    }

    for (UIView *subView in _searchBar.subviews) {
        for (UIView *ndLeveSubView in subView.subviews) {
            if ([ndLeveSubView isKindOfClass:[UITextField class]]) {
                UITextField *sbTextField = (UITextField *)ndLeveSubView;
                sbTextField.backgroundColor = COLOR_78_152_73;
                sbTextField.textColor = [UIColor whiteColor];
                if ([sbTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                    UIColor *color = [UIColor whiteColor];
                    sbTextField.attributedPlaceholder = [[NSAttributedString alloc]
                        initWithString:self.placeholder
                            attributes:@{NSForegroundColorAttributeName : color}];
                    UIImage *image = [UIImage imageNamed:@"icon_search"];
                    UIImage *rightImage = [UIImage imageNamed:@"btn_cleartxt"];
                    sbTextField.leftView = [[UIImageView alloc] initWithImage:image];
                    UIButton *clearButton = [sbTextField valueForKey:@"_clearButton"];
                    [clearButton setImage:rightImage forState:UIControlStateNormal];
                } else {
                    PTLogDebug(@"Cannot set placeholder text's color, because deployment target is "
                               @"earlier than iOS 6.0");
                }
                break;
            }
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

    _cancelButton = [[UIButton alloc] init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self
                      action:@selector(cancelSearch:)
            forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_searchBar];
    [self addSubview:_cancelButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat padding = NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 ? 0 : 3;

    _searchBar.frame = CGRectMake(MARGIN - padding, 0,
                                  CGRectGetWidth(self.bounds) - 2 * MARGIN - 60 + padding, 30);
    _searchBar.center = CGPointMake(_searchBar.center.x, CGRectGetHeight(self.frame) - 22);
    _cancelButton.frame = CGRectMake(0, 0, 50, 30);
    _cancelButton.center =
        CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(_cancelButton.frame) / 2 - 15,
                    CGRectGetMidY(_searchBar.frame));
    [_cancelButton setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
}

#pragma mark - event
- (IBAction)cancelSearch:(id)sender
{
    if (_delegateRespondsTo.isImplementSearchCanceled) {
        [self.delegate searchBar:self searchCanceled:YES];
    }
}

- (void)searchTextChanged:(NSNotification *)notification
{
    if (_delegateRespondsTo.isImplementSearchBarTextChanged) {
        [self.delegate searchBar:self textChanged:_searchBar.text];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (_delegateRespondsTo.isImplementSearchText) {
        [self.delegate searchBar:self searchText:searchBar.text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *temp = searchBar.text;
    NSUInteger limitLengthText = _maxLengthText > 0 ?: 100;
    if (temp.length > limitLengthText) {
        searchBar.text = [temp substringToIndex:limitLengthText];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text
{
    return YES;
}


@end
