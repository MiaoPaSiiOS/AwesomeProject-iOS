//
//  ESHomeViewController.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import "ESHomeViewController.h"
#import "ESSettingViewController.h"

@interface ESHomeViewController ()

@end

@implementation ESHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新品";
    
    NrBarButtonItem *rightBarButtonItem = [[NrBarButtonItem alloc] initWithTitle:@"设置" target:self action:@selector(showDisplayOfCommonFunctions)];
    rightBarButtonItem.titleColor = [UIColor blackColor];
    self.appBar.rightBarButtonItem = rightBarButtonItem;
}

- (void)showDisplayOfCommonFunctions {
    ESSettingViewController *screen = [[ESSettingViewController alloc] init];
    [self.navigationController pushViewController:screen animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
