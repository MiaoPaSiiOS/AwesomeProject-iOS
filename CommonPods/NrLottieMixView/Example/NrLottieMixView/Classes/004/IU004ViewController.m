//
//  IU004ViewController.m
//  NrLottieMixView_Example
//
//  Created by zhuyuhui on 2023/1/9.
//  Copyright © 2023 zhuyuhui434@gmail.com. All rights reserved.
//

#import "IU004ViewController.h"
#import <Lottie/Lottie.h>
#import <NrLottieMixView/NrLottieMixView.h>
@interface IU004ViewController ()
@property (nonatomic, strong) LOTAnimationView *loader;
@end

@implementation IU004ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loader];
    // Do any additional setup after loading the view.
    [self replaceTitle];
    [self replaceSubTitle];
    [self replaceAdView];
    [self replaceBottomButtons];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.loader play];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.loader pause];
}


#pragma mark - 替换弹框
- (void)replaceTanKuang {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"004-animation" ofType:@"bundle"];
//    UIImage *bgImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/images/img_3.png",path]];
//
//    NrLOTGIFImageView *view2 = [[NrLOTGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 900, 1172)];
//    view2.layer.borderColor = [UIColor blueColor].CGColor;
//    view2.layer.borderWidth = 4;
//    view2.image = bgImage;
//    [self.loader addSubview:view2 toKeypathLayer:[LOTKeypath keypathWithString:@"弹窗1"]];
}

#pragma mark - 替换标题
- (void)replaceTitle {
    
}

- (void)replaceSubTitle {
//    LOTKeypath *keypath = [LOTKeypath keypathWithString:@"福利不停 ， 再送你专属分期券"];

    UILabel *view1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view1.text = @"福利不停 ， 再送你专属分期券";
    view1.font = [UIFont systemFontOfSize:30];
    view1.layer.borderColor = [UIColor blueColor].CGColor;
    view1.layer.borderWidth = 4;

//    view1.frame = [self.loader convertRect:view1.bounds toKeypathLayer:keypath];
//    [self.loader addSubview:view1 toKeypathLayer:keypath];
    [self.loader addSubview:view1 withLayerName:@"福利不停 ， 再送你专属分期券"];
}

#pragma mark - 替换广告位图片
- (void)replaceAdView {
    NSArray *gifs = @[
        @"https://img.zcool.cn/community/0193385d7f8cada801211d532d307b.gif",
        @"https://img.zcool.cn/community/01ef345bcd8977a8012099c82483d3.gif",
        @"https://img.zcool.cn/community/01e6295b0242b3a801209a852510cd.gif"
    ];
    //270-139
    //      "w": 828, "h": 423,  弹窗-banner
    NrLOTGIFImageView *view2 = [[NrLOTGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 828, 423)];
    view2.layer.borderColor = [UIColor blueColor].CGColor;
    view2.layer.borderWidth = 4;
    
    [self.loader addSubview:view2 withLayerName:@"弹窗-banner"];
    view2.url = @"https://img.zcool.cn/community/01639c586c91bba801219c77f6efc8.gif";
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAd)];
    [view2 addGestureRecognizer:tap];
}

- (void)clickAd {
    [self alertMsg:@"clickAd"];
}



#pragma mark - 替换底部按钮
- (void)replaceBottomButtons {
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 360, 129)];
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    leftBtn.layer.borderColor = UIColor.redColor.CGColor;
    leftBtn.layer.borderWidth = 10;
    [leftBtn addTarget:self action:@selector(clickLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.loader addSubview:leftBtn withLayerName:@"button-先不要了" removeOriginal:NO];
//    [self.imageView addSubview:leftBtn toKeypathLayer:[LOTKeypath keypathWithString:@"button-先不要了"]];


    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 390, 176)];
    [rightBtn setTitle:@"" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.layer.borderColor = UIColor.redColor.CGColor;
    rightBtn.layer.borderWidth = 10;
    [rightBtn addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
    [self.loader addSubview:rightBtn withLayerName:@"button-立即领取" removeOriginal:NO];
}



- (void)clickLeft {
    [self alertMsg:@"clickLeft"];
}
- (void)clickRight {
    [self alertMsg:@"clickRight"];
}


#pragma mark - Util

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
        NSString *path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"004-animation" ofType:@"bundle"]] pathForResource:@"data" ofType:@"json"];
        _loader = [LOTAnimationView animationWithFilePath:path];
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        _loader.backgroundColor = [UIColor whiteColor];
        _loader.loopAnimation = YES;
        _loader.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _loader.contentMode = UIViewContentModeScaleAspectFill;
        
        /*
         "w": 1125,
         "h": 1650,
         */
        CGFloat x = 15;
        CGFloat w = self.view.frame.size.width - x * 2;
        CGFloat h = w / (1125/1650.0);
        
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _loader.frame = CGRectMake(x, y, w, h);
    }
    return _loader;
}
@end
