//
//  REMineViewController.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "REMineViewController.h"

@interface REMineViewController ()

@end

@implementation REMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PhoneRouter singletonInstance] routerWithUrlString:[NSString getRouterVCUrlStringFromUrlString:kSettingPage andParams:nil] navigationController:self.navigationController];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
