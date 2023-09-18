//
//  NrNavigationController.m
//  NrViewController
//
//  Created by zhuyuhui on 2022/6/27.
//

#import "NrNavigationController.h"

@interface NrNavigationController ()

@end

@implementation NrNavigationController

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
