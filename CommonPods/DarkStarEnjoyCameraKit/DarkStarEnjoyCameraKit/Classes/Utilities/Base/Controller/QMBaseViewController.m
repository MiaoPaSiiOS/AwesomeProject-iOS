//
//  QMBaseViewController.m
//  AmenEnjoyCamera
//
//  Created by zhuyuhui on 2021/7/5.
//

#import "QMBaseViewController.h"

@interface QMBaseViewController ()

@end

@implementation QMBaseViewController
- (void)dealloc
{
    NSLog(@"%@", self);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - Orientation
//是否跟随屏幕旋转
- (BOOL)shouldAutorotate{
    return NO;
}
//支持旋转的方向有哪些
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskAll);
}
//控制 vc present进来的横竖屏和进入方向 ，支持的旋转方向必须包含改返回值的方向 （详细的说明见下文）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
