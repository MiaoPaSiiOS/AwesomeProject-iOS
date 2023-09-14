//
//  RESettingViewController.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "RESettingViewController.h"

@interface RESettingViewController ()

@end

@implementation RESettingViewController

+ (void)load {
    [[RERouter singletonInstance] registerClass:self key:kSettingPage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
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
