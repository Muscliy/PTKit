//
//  PTReactiveCocoaDemoViewController.m
//  PTKit
//
//  Created by LeeHu on 5/25/15.
//  Copyright (c) 2015 LeeHu. All rights reserved.
//

#import "PTReactiveCocoaDemoViewController.h"
#import <ReactiveCocoa.h>

@interface PTReactiveCocoaDemoViewController ()

@end

@implementation PTReactiveCocoaDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block int aNumber = 0;
    
    // Signal that will have the side effect of incrementing `aNumber` block
    // variable for each subscription before sending it.
    RACSignal *aSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        aNumber++;
        [subscriber sendNext:@(aNumber)];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // This will print "subscriber one: 1"
    [aSignal subscribeNext:^(id x) {
        NSLog(@"subscriber one: %@", x);
    }];
    
    // This will print "subscriber two: 2"
    [aSignal subscribeNext:^(id x) {
        NSLog(@"subscriber two: %@", x);
    }];
    
    __block int missilesToLaunch = 0;
    // Signal that will have the side effect of changing `missilesToLaunch` on
    // subscription.
    RACSignal *processedSignal = [[RACSignal
                                   return:@"missiles"]
                                  map:^(id x) {
                                      missilesToLaunch++;
                                      return [NSString stringWithFormat:@"will launch %d %@", missilesToLaunch, x];
                                  }];
    
    // This will print "First will launch 1 missiles"
    [processedSignal subscribeNext:^(id x) {
        NSLog(@"First %@", x);
    }];
    
    // This will print "Second will launch 2 missiles"
    [processedSignal subscribeNext:^(id x) {
        NSLog(@"Second %@", x);
    }];
    
}

@end
