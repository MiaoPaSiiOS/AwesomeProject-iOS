//
//  DSNavigationController.m
//  DSViewController
//
//  Created by zhuyuhui on 2022/6/27.
//

#import "DSNavigationController.h"

@interface DSNavigationController ()

@end

@implementation DSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
