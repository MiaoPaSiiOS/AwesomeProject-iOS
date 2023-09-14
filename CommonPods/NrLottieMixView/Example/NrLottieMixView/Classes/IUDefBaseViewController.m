//
//  IUDefBaseViewController.m
//  NrLottieMixView_Example
//
//  Created by zhuyuhui on 2023/1/9.
//  Copyright © 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUDefBaseViewController.h"

@interface IUDefBaseViewController ()

@end

@implementation IUDefBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


- (void)alertMsg:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题"message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
