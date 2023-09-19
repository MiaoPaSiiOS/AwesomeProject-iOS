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
    [self.navigationController pushViewController:[RESettingViewController new] animated:YES];
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
