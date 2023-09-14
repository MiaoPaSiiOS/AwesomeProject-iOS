//
//  IUDefaultViewController.m
//  NrLottieMixView_Example
//
//  Created by zhuyuhui on 2023/1/9.
//  Copyright © 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IUDefaultViewController.h"
#import <Lottie/Lottie.h>
@interface IUDefaultViewController ()
@property (nonatomic, strong) LOTAnimationView *loader;
@end

@implementation IUDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self test_json_1];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.loader play];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.loader pause];
}



- (void)test_json_1 {
    LOTKeypath *layerKeypath = [LOTKeypath keypathWithString:@"Shape Layer 1.Rectangle 1.Rectangle Path 1"];

    UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    orangeView.backgroundColor = [UIColor orangeColor];

    [self.loader addSubview:orangeView toKeypathLayer:layerKeypath];

    [self.view addSubview:self.loader];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (LOTAnimationView *)loader {
    if (_loader == nil) {
        _loader = [LOTAnimationView animationNamed:@"setValueTest" inBundle:[NSBundle mainBundle]];
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        _loader.backgroundColor = [UIColor whiteColor];
        _loader.loopAnimation = YES;
        
        /*
         "w": 300,
         "h": 300,
         */
        CGFloat x = 15;
        CGFloat w = self.view.frame.size.width - x * 2;
        CGFloat h = w / (300/300);
        
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _loader.frame = CGRectMake(x, y, w, h);
    }
    return _loader;
}
@end
