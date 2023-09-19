//
//  RENewsViewController.m
//  DarkStar
//
//  Created by zhuyuhui on 2023/6/13.
//

#import "RENewsViewController.h"

@interface RENewsViewController ()

@end

@implementation RENewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refresh];
}

- (void)refresh {
    [DSGifWaitView showWaitViewInController:self style:BlueWaitStyle];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DSGifWaitView hideWaitViewInController:self];
        [self.dsView showErrorViewWithType:DSErrorTypeSeverError target:self action:@selector(refresh)];
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
