//
//  IU005ViewController.m
//  NrLottieMixView_Example
//
//  Created by zhuyuhui on 2023/1/9.
//  Copyright © 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IU005ViewController.h"
#import <Lottie/Lottie.h>
@interface IU005ViewController ()
@property (nonatomic, strong) LOTAnimationView *loader;
@end

@implementation IU005ViewController

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
//    //修改背景为紫色
//    LOTKeypath *boatKeypath = [LOTKeypath keypathWithString:@"Bg.Rectangle 1.Fill 1.Color"];
//
//    LOTColorBlockCallback *colorCallback = [LOTColorBlockCallback withBlock:^CGColorRef _Nonnull(CGFloat currentFrame, CGFloat startKeyFrame, CGFloat endKeyFrame, CGFloat interpolatedProgress, CGColorRef  _Nullable startColor, CGColorRef  _Nullable endColor, CGColorRef  _Nullable interpolatedColor) {
//        return UIColor.purpleColor.CGColor;
//    }];
//    [self.loader setValueDelegate:colorCallback forKeypath:boatKeypath];

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
        NSString *path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"005-animation" ofType:@"bundle"]] pathForResource:@"data" ofType:@"json"];
        _loader = [LOTAnimationView animationWithFilePath:path];
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        _loader.backgroundColor = [UIColor whiteColor];
        _loader.loopAnimation = YES;
        _loader.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        _loader.frame = self.view.bounds;
    }
    return _loader;
}
@end
