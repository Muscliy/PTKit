//
//  PTDynamicsViewController.m
//  PTKit
//
//  Created by LeeHu on 8/25/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTDynamicsViewController.h"

@interface PTDynamicsViewController ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *av;
@property (nonatomic, strong) UIAttachmentBehavior* attachmentBehavior;

@end

@implementation PTDynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _av = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    _av.backgroundColor = [UIColor redColor];
    [self.view addSubview:_av];
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *behavior = [[UIGravityBehavior alloc] initWithItems:@[_av]];
    [animator addBehavior:behavior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_av]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
    
    self.animator = animator;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleAttachmentGesture:)];
    [self.view addGestureRecognizer:pan];
}

- (void)handleAttachmentGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint itemViewCenter = CGPointMake(self.av.center.x, self.av.center.y);        
        UIOffset offset = UIOffsetMake(-25, -25);
        
        UIAttachmentBehavior* attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.av offsetFromCenter:offset attachedToAnchor:itemViewCenter];
        self.attachmentBehavior = attachmentBehavior;
        [self.animator addBehavior:self.attachmentBehavior];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachmentBehavior];
    }
}

@end
