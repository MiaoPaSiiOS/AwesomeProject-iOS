//
//  REMineViewController.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "REMineViewController.h"
#import "RESettingViewController.h"
@interface REMineViewController ()

@end

@implementation REMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh {
    [DSGifWaitView showWaitViewInController:self style:BlueWaitStyle];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DSGifWaitView hideWaitViewInController:self];
        [self.dsView showErrorViewWithType:DSErrorTypeUnavailableNetwork target:self action:@selector(refresh)];
    });
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
