//
//  PTLayoutTableViewCell.m
//  PTKit
//
//  Created by LeeHu on 8/14/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTLayoutTableViewCell.h"
#import "Masonry.h"

@interface PTLayoutTableViewCell ()

@property (nonatomic, strong) MASConstraint *cF; //constraint first row
@property (nonatomic, strong) MASConstraint *cB; //constraint blue
@property (nonatomic, strong) MASConstraint *cY; //constraint yellow
@property (nonatomic, strong) MASConstraint *cR; //constraint red
@property (nonatomic, strong) MASConstraint *cG; //constraint green

@property (nonatomic, strong) UIView *vB; //view blue    height:30
@property (nonatomic, strong) UIView *vY; //view yellow  height:30
@property (nonatomic, strong) UIView *vR; //view red     height:30
@property (nonatomic, strong) UIView *vG; //view green   height:100

@property (nonatomic, strong) UIView *gF; //group first row
@property (nonatomic, strong) UIView *gB; //group blue
@property (nonatomic, strong) UIView *gY; //group yellow
@property (nonatomic, strong) UIView *gR; //group red
@property (nonatomic, strong) UIView *gG; //group green

@end

@implementation PTLayoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        CGFloat spacing = 20.0f;
        
        _vB = [UIView new];
        _vY = [UIView new];
        _vR = [UIView new];
        _vG = [UIView new];
        
        [self.contentView addSubview:_vB];
        [self.contentView addSubview:_vY];
        [self.contentView addSubview:_vR];
        [self.contentView addSubview:_vG];
        
        
        [_vB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing, spacing, 0, 0));
            make.width.equalTo(@60);
            make.height.equalTo(@30).priorityLow();
            //self.cB = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _vB.backgroundColor = [UIColor blueColor];
        
        [_vY mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vB.mas_right).offset(spacing);
            make.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing, 0, 0, spacing));
            make.height.equalTo(@30).priorityLow();
            //self.cY = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _vY.backgroundColor = [UIColor yellowColor];
        
        [_vR mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vB.mas_bottom).offset(spacing);
            make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
            make.height.equalTo(@30).priorityLow();
            self.cR = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _vR.backgroundColor = [UIColor redColor];
        
        [_vG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vR.mas_bottom).offset(spacing);
            make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
            make.height.equalTo(@100).priorityLow();
            //self.cG = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
        }];
        
        _vG.backgroundColor = [UIColor greenColor];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat spacing = 20.0f;
//
//    [_vB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing, spacing, 0, 0));
//        make.width.equalTo(@60);
//        make.height.equalTo(@30);
//        self.cB = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
//    }];
//    
//    _vB.backgroundColor = [UIColor blueColor];
//    
//    [_vY mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.vB.mas_right).offset(spacing);
//        make.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(spacing, 0, 0, spacing));
//        make.height.equalTo(@30).priorityLow();
//        self.cY = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
//    }];
//    
//    _vY.backgroundColor = [UIColor yellowColor];
//    
//    [_vR mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vB.mas_bottom).offset(spacing);
//        make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
//        make.height.equalTo(@30).priorityLow();
//        self.cR = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
//    }];
//    
//    _vR.backgroundColor = [UIColor redColor];
//    
//    [_vG mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vR.mas_bottom).offset(spacing);
//        make.left.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, spacing, 0, spacing));
//        make.height.equalTo(@100).priorityLow();
//        self.cG = make.height.equalTo(@0).priority(UILayoutPriorityRequired);
//    }];
//    
//    _vG.backgroundColor = [UIColor greenColor];
}


+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 240;
}

@end

@implementation PTLayoutTableViewCellUserData

@end
