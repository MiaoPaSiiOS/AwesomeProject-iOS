//
//  TestViewController.m
//  IU_TransitionAnimator_Example
//
//  Created by zhuyuhui on 2021/6/5.
//  Copyright © 2021 zhuyuhui434@gmail.com. All rights reserved.
//

#import "TestViewController.h"
#import <LDZFTransitionAnimator/LDZFTransitionAnimator.h>

@interface TestViewController ()

@end

@implementation TestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.layer.cornerRadius = 16;
    self.view.layer.masksToBounds = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    TestViewController *testVC = [[TestViewController alloc] init];
    LdzfAnimationCenterFromTop *animation = [[LdzfAnimationCenterFromTop alloc] init];
    [self presentViewController:testVC animation:animation completion:nil];

}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end
