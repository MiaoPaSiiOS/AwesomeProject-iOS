//
//  QMPhotoDisplayViewController.m
//  EnjoyCamera
//
//  Created by qinmin on 2017/10/13.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMPhotoDisplayViewController.h"
#import "Constants.h"
#import "QMShakeButton.h"
#import "QMShareManager.h"
#import "QMPhotoEffectViewController.h"
#import "QMProgressHUD.h"
#import <Photos/Photos.h>

@interface QMPhotoDisplayViewController ()
{
    CGFloat _cameraViewBottomBGHeight;
    CGFloat _currentCameraViewRatio;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *topBg;
@property (nonatomic, strong) UIView *bottomBg;
@end

@implementation QMPhotoDisplayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupVar];
    [self setupUI];
    [self setPhotoRatio];
}

#pragma mark - SETUP
- (void)setupVar
{
    _cameraViewBottomBGHeight = (([DSCommonMethods screenHeight])-([DSCommonMethods screenWidth])*(4.0f/3.0f));
    _currentCameraViewRatio = 1.33f;
}

- (void)setupUI
{
    // NavigationBar
    self.view.backgroundColor = [UIColor blackColor];
    
    // GPUImageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.frame = CGRectMake(0, 0, [DSCommonMethods screenWidth], [DSCommonMethods screenWidth]*4.0/3.0);
    _imageView.image = _image;
    [self.view addSubview:_imageView];
    
    // 顶部背景
    UIView *topBg = [[UIView alloc] initWithFrame:CGRectZero];
    topBg.frame = CGRectMake(0, [DSCommonMethods statusBarHeight], [DSCommonMethods screenWidth], [DSCommonMethods naviBarContentHeight]);
    topBg.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:255.0];
    [self.view addSubview:topBg];
    _topBg = topBg;
    
    // 返回
    UIButton *backPhotoBtn = [[QMShakeButton alloc] init];
    [backPhotoBtn setImage:[AECResouce imageNamed:@"qmkit_photo_back"] forState:UIControlStateNormal];
    [backPhotoBtn setImage:[AECResouce imageNamed:@"qmkit_photo_back"] forState:UIControlStateHighlighted];
    [backPhotoBtn addTarget:self action:@selector(backPhotoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [topBg addSubview:backPhotoBtn];
    [backPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
        make.left.mas_offset(10);
    }];
    
    // 分享
    UIButton *sharePhotoBtn = [[QMShakeButton alloc] init];
    [sharePhotoBtn setImage:[AECResouce imageNamed:@"qmkit_photo_share"] forState:UIControlStateNormal];
    [sharePhotoBtn setImage:[AECResouce imageNamed:@"qmkit_photo_share"] forState:UIControlStateHighlighted];
    [sharePhotoBtn addTarget:self action:@selector(sharePhotoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [topBg addSubview:sharePhotoBtn];
    [backPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(44);
        make.right.mas_offset(-10);
    }];
    
    
    // 底部背景
    UIView *bottomBg = [[UIView alloc] init];
    bottomBg.frame = CGRectMake(0, [DSCommonMethods screenHeight]-_cameraViewBottomBGHeight, [DSCommonMethods screenWidth], _cameraViewBottomBGHeight);
    bottomBg.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:255.0];
    [self.view addSubview:bottomBg];
    _bottomBg = bottomBg;

    
    
//    UILabel *backPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/6-40/2, kScreenH-kCameraViewBottomBGHeight/2+40/2, 40, 40)];
//    backPhotoLabel.text = @"返回";
//    backPhotoLabel.textAlignment = NSTextAlignmentCenter;
//    backPhotoLabel.font = [UIFont systemFontOfSize:14];
//    backPhotoLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:backPhotoLabel];
    
    // 保存
    UIButton *savePhotoBtn = [[QMShakeButton alloc] init];
    [savePhotoBtn setImage:[AECResouce imageNamed:@"qmkit_save_photo_btn"] forState:UIControlStateNormal];
    [savePhotoBtn setImage:[AECResouce imageNamed:@"qmkit_save_photo_btn"] forState:UIControlStateHighlighted];
    [savePhotoBtn addTarget:self action:@selector(savePhotoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBg addSubview:savePhotoBtn];
    [savePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(80);
    }];
    
    // 滤镜
    UIButton *filterPhotoBtn = [[QMShakeButton alloc] init];
    [filterPhotoBtn setImage:[AECResouce imageNamed:@"qmkit_photo_filter"] forState:UIControlStateNormal];
    [filterPhotoBtn setImage:[AECResouce imageNamed:@"qmkit_photo_filter"] forState:UIControlStateHighlighted];
    [filterPhotoBtn addTarget:self action:@selector(filterPhotoBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBg addSubview:filterPhotoBtn];
    [filterPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(35);
        make.left.equalTo(savePhotoBtn.mas_right).offset(30);
    }];
}

- (void)setPhotoRatio
{
    CGFloat ratio = (float)CGImageGetHeight(_image.CGImage)/(float)CGImageGetWidth(_image.CGImage);
    [self setCameraRatio:ratio];
}

#pragma mark - 调整相机比例
- (void)setCameraRatio:(CGFloat)ratio
{
    _currentCameraViewRatio = ratio;
    float vaW = [DSCommonMethods screenWidth];
    float vaH = [DSCommonMethods screenWidth]*4.0/3.0;
    float igW = 0, igH = 0;
    if (ratio == 1) {
        igW = vaW;
        igH = vaW;
    } else if (ratio > 1) {
        igW = vaH / ratio;
        igH = vaH;
    } else {
        igW = vaW;
        igH = vaW * ratio;
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.imageView.frame = CGRectMake((vaW - igW) / 2, (vaH - igH) / 2, igW, igH);
    }];
}




- (void)saveImage
{
    [QMProgressHUD show];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self->_image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        [QMProgressHUD hide];
    }];
}


#pragma mark - PublicMethod
- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = _image;
}

#pragma mark - Event
- (void)backPhotoBtnTapped:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePhotoBtnTapped:(UIButton *)sender
{
    [self saveImage];
}
- (void)filterPhotoBtnTapped:(UIButton *)sender
{
    QMPhotoEffectViewController *photoEdit = [[QMPhotoEffectViewController alloc] initWithImage:self.image];
    [self.navigationController pushViewController:photoEdit animated:YES];
}

- (void)sharePhotoBtnTapped:(UIButton *)sender
{
    [QMShareManager shareThumbImage:self.image inViewController:self];
}

@end
