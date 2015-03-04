//
//  PTFontListViewController.m
//  PTKit
//
//  Created by LeeHu on 15/3/3.
//  Copyright (c) 2015年 LeeHu. All rights reserved.
//

#import "PTFontListViewController.h"

@interface PTFontListViewController ()

@end

@implementation PTFontListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self createLabelWithFrame:CGRectMake(10, 10, 100, 30)
                       andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    [self createLabelWithFrame:CGRectMake(120, 10, 100, 30)
                       andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];

    [self createLabelWithFrame:CGRectMake(10, 50, 100, 30)
                       andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];

    [self createLabelWithFrame:CGRectMake(120, 50, 100, 30)
                       andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption2]];

    [self createLabelWithFrame:CGRectMake(10, 90, 100, 30)
                       andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];

    [self createLabelWithFrame:CGRectMake(120, 90, 100, 30)
                       andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
}

- (void)createLabelWithFrame:(CGRect)rect andFont:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.layer.masksToBounds = YES;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.text = @"睡懒觉了是死了";
    label.font = font;
    label.textColor = [UIColor blackColor];
    NSLog(@"%@",font.fontDescriptor.fontAttributes);
    [self.view addSubview:label];
}
/*
2015-03-03 11:53:03.393 PTKit[29978:840341] {
    NSCTFontUIUsageAttribute = UICTFontTextStyleSubhead;
    NSFontSizeAttribute = 15;
}
2015-03-03 11:53:03.394 PTKit[29978:840341] {
    NSCTFontUIUsageAttribute = UICTFontTextStyleHeadline;
    NSFontSizeAttribute = 17;
}
2015-03-03 11:53:03.394 PTKit[29978:840341] {
    NSCTFontUIUsageAttribute = UICTFontTextStyleFootnote;
    NSFontSizeAttribute = 13;
}
2015-03-03 11:53:03.394 PTKit[29978:840341] {
    NSCTFontUIUsageAttribute = UICTFontTextStyleCaption2;
    NSFontSizeAttribute = 11;
}
2015-03-03 11:53:03.395 PTKit[29978:840341] {
    NSCTFontUIUsageAttribute = UICTFontTextStyleCaption1;
    NSFontSizeAttribute = 12;
}
2015-03-03 11:53:03.395 PTKit[29978:840341] {
    NSCTFontUIUsageAttribute = UICTFontTextStyleBody;
    NSFontSizeAttribute = 17;
}
*/
@end
