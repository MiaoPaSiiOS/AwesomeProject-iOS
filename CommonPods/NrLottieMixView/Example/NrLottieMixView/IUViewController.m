//
//  IUViewController.m
//  NrLottieMixView
//
//  Created by zhuyuhui434@gmail.com on 01/09/2023.
//  Copyright (c) 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUViewController.h"
#import "MainViewController.h"
@interface IUViewController ()

@end

@implementation IUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushTestVC:(id)sender {
    MainViewController *vc = [[MainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
