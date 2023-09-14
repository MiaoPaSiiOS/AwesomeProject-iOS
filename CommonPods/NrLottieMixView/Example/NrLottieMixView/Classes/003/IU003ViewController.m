//
//  IU003ViewController.m
//  NrLottieMixView_Example
//
//  Created by zhuyuhui on 2023/1/9.
//  Copyright © 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IU003ViewController.h"
#import <Lottie/Lottie.h>
#import <NrLottieMixView/NrLottieMixView.h>
#import "HongBaoView.h"
@interface IU003ViewController ()
@property (nonatomic, strong) LOTAnimationView *loader;
@end

@implementation IU003ViewController

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
    // 获取背景图
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hongbao-animation" ofType:@"bundle"];
    UIImage *bgImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/images/LottieMixViewBG.png",path]];
    
    //替换View
    HongBaoView *view = [[[NSBundle mainBundle] loadNibNamed:@"HongBaoView" owner:nil options:nil]lastObject];
    view.bgView.image = bgImage;
    [self.loader addSubview:view withLayerName:@"卡"];

    
    
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [closeBtn setTitle:@"" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    closeBtn.layer.borderColor = UIColor.redColor.CGColor;
    closeBtn.layer.borderWidth = 10;
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.loader addSubview:closeBtn withLayerName:@"▽ ic_按钮" removeOriginal:NO];

    
        
    [self.view addSubview:self.loader];
}

- (void)clickCloseBtn {
    [self alertMsg:@"点击关闭按钮"];
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
        NSString *path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"hongbao-animation" ofType:@"bundle"]] pathForResource:@"data" ofType:@"json"];
        _loader = [LOTAnimationView animationWithFilePath:path];
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        _loader.backgroundColor = [UIColor whiteColor];
//        _loader.loopAnimation = YES;
        _loader.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        _loader.frame = self.view.bounds;
    }
    return _loader;
}
@end
