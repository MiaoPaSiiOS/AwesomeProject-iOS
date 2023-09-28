//
//  QMCameraViewController.m
//  EnjoyCamera
//
//  Created by qinmin on 2017/4/13.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMCameraViewController.h"
#import <Photos/Photos.h>
#import <TZImagePickerController/TZImagePickerController.h>

#import "QMPhotoClipViewController.h"
#import "QMPhotoEffectViewController.h"
#import "QMCameraSettingViewController.h"
#import "QMShakeButton.h"
#import "CKStillCamera.h"
#import "CKStillCameraPreview.h"
#import "PHAsset+Latest.h"
#import "QMCameraRatioSuspensionView.h"
#import "QMCameraFlashSuspensionView.h"
#import "QMCameraFilterView.h"
#import "QMImageFilter.h"
#import "QMPhotoDisplayViewController.h"
#import "UIImage+Rotate.h"
#import "UIImage+Clip.h"
#import "QMCameraFocusView.h"
#import "QMProgressHUD.h"
#import "Constants.h"

@interface QMCameraViewController ()<TZImagePickerControllerDelegate,TOCropViewControllerDelegate>
{
    QMCameraRatioSuspensionView *_ratioSuspensionView;
    QMCameraFlashSuspensionView *_flashSuspensionView;
    QMCameraFocusView *_foucusView;
    QMCameraFilterView *_cameraFilterView;
    CGFloat _currentCameraViewRatio;
    CGFloat _lastTwoFingerDistance;
    CGFloat _cameraViewBottomBGHeight;
    CGFloat _cameraTakePhotoIconSize;
}
@property (nonatomic, strong) CKStillCamera *stillCamera;
@property (nonatomic, strong) CKStillCameraPreview *imageView;
@property (nonatomic, strong) GPUImageFilter *filter;
@property (nonatomic, assign) CGFloat currentSwipeFilterIndex;

@property (nonatomic, strong) UIView *topBg;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *bottomBg;
@property (nonatomic, strong) UIButton *takePhotoBtn;
@property (nonatomic, strong) UIButton *picBtn;

@property (nonatomic, assign) AVCaptureTorchMode currentTorchModel;
@property (nonatomic, assign) AVCaptureFlashMode currentFlashModel;
@end

@implementation QMCameraViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupVar];
    [self setupUI];
    [self setupCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.takePhotoBtn.userInteractionEnabled = NO;
    
    // 开始捕捉
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        [self startCameraCapture];
    });
    
    // 相册加载
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self asyncLoadLatestImageFromPhotoLib];
            }
        }];
    }else {
        [self asyncLoadLatestImageFromPhotoLib];
    }
}

#pragma mark - SETUP
- (void)setupVar
{
    _cameraViewBottomBGHeight = ((DSDeviceInfo.screenHeight)-(DSDeviceInfo.screenWidth)*(4.0f/3.0f));
    _cameraTakePhotoIconSize = 75;
    _currentCameraViewRatio = 1.33f;
    _currentFlashModel = AVCaptureFlashModeOff;
    _currentTorchModel = AVCaptureTorchModeOff;
}

- (void)setupUI
{
    @iUweakify(self)
    // GPUImageView
    _imageView = [[CKStillCameraPreview alloc] initWithFrame:CGRectZero];
    _imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    _imageView.frame = CGRectMake(0, 0, DSDeviceInfo.screenWidth, DSDeviceInfo.screenWidth*4.0/3.0);
    [self.view addSubview:_imageView];
        
    // 自动对焦
    [_imageView.tapGestureSignal subscribeNext:^(UITapGestureRecognizer* _Nullable x) {
        @iUstrongify(self)
        BOOL ratioHidden = [self.ratioSuspensionView hide];
        BOOL flashHidden = [self.flashSuspensionView hide];
        BOOL cameraHidden = [self.cameraFilterView hide];
        if (ratioHidden || flashHidden || cameraHidden) {
            return;
        }
        
        // foucus
        CGPoint center = [x locationInView:self.view];
        CGPoint foucus = CGPointMake(center.x/self.imageView.frame.size.width, 1.0-center.y/self.imageView.frame.size.height);
        [self.stillCamera setExposeModel:AVCaptureExposureModeContinuousAutoExposure];
        [self.stillCamera focusAtPoint:foucus];
        [self.cameraFocusView foucusAtPoint:center];
    }];
    
    // 视频缩放
    [[_imageView.pinchGestureSignal filter:^BOOL(UIPinchGestureRecognizer* _Nullable value) {
        return value.numberOfTouches == 2;
    }] subscribeNext:^(UIPinchGestureRecognizer* _Nullable x) {
        @iUstrongify(self)
        CGPoint first = [x locationOfTouch:0 inView:self.imageView];
        CGPoint second = [x locationOfTouch:1 inView:self.imageView];
        if (x.state == UIGestureRecognizerStateBegan) {
            self->_lastTwoFingerDistance = sqrt(pow(first.x - second.x, 2) + pow(first.y-second.y, 2));
        }else if (x.state == UIGestureRecognizerStateChanged) {
            CGFloat twoFingerDistance = sqrt(pow(first.x - second.x, 2) + pow(first.y-second.y, 2));
            CGFloat scale = (twoFingerDistance - self->_lastTwoFingerDistance)/self->_lastTwoFingerDistance;
            [self.stillCamera setVideoZoomFactor:scale+self.stillCamera.videoZoomFactor];
            self->_lastTwoFingerDistance = twoFingerDistance;
        }else if (x.state == UIGestureRecognizerStateEnded) {
            self->_lastTwoFingerDistance = sqrt(pow(first.x - second.x, 2) + pow(first.y-second.y, 2));
        }else if (x.state == UIGestureRecognizerStateCancelled) {
            self->_lastTwoFingerDistance = sqrt(pow(first.x - second.x, 2) + pow(first.y-second.y, 2));
        }
    }];
    
    // 轻扫右
    [_imageView.swipeRightGestureSignal subscribeNext:^(UISwipeGestureRecognizer*  _Nullable x) {
        @iUstrongify(self)
        self.currentSwipeFilterIndex -= 1;
        self.currentSwipeFilterIndex = ([[self cameraFilterView] selectFilterAtIndex:self.currentSwipeFilterIndex]) ? self.currentSwipeFilterIndex : self.currentSwipeFilterIndex + 1;
        
    }];
    
    // 轻扫左
    [_imageView.swipeLeftGestureSignal subscribeNext:^(UISwipeGestureRecognizer*  _Nullable x) {
        @iUstrongify(self)
        self.currentSwipeFilterIndex += 1;
        self.currentSwipeFilterIndex = ([[self cameraFilterView] selectFilterAtIndex:self.currentSwipeFilterIndex]) ? self.currentSwipeFilterIndex : self.currentSwipeFilterIndex - 1;
    }];
    
    // 顶部背景
    UIView *topBg = [[UIView alloc] initWithFrame:CGRectZero];
    topBg.frame = CGRectMake(0, SafeAreaInsetsConstantForDeviceWithNotch.top, DSDeviceInfo.screenWidth, DSDeviceInfo.naviBarContentHeight);
    topBg.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:255.0];
    [self.view addSubview:topBg];
    _topBg = topBg;
        
    // 退出
    UIButton *dismissBtn = [[QMShakeButton alloc] initWithFrame:CGRectZero];
    [dismissBtn setImage:[AECResouce imageNamed:@"qmkit_photo_back"] forState:UIControlStateNormal];
    [dismissBtn setImage:[AECResouce imageNamed:@"qmkit_photo_back"] forState:UIControlStateHighlighted];
    [topBg addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    [[dismissBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    // 闪光灯
    UIButton *flashBtn = [[QMShakeButton alloc] initWithFrame:CGRectZero];
    [flashBtn setImage:[AECResouce imageNamed:@"qmkit_no_flash_btn"] forState:UIControlStateNormal];
    [flashBtn setImage:[AECResouce imageNamed:@"qmkit_no_flash_btn"] forState:UIControlStateHighlighted];
    [topBg addSubview:flashBtn];
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(dismissBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
    }];
    [[flashBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        [self.flashSuspensionView setFlashCallBack:^(AVCaptureFlashMode flash, AVCaptureTorchMode torch, NSString *icon) {
            self.currentTorchModel = torch;
            self.currentFlashModel = flash;
            [flashBtn setImage:[AECResouce imageNamed:icon] forState:UIControlStateNormal];
            [flashBtn setImage:[AECResouce imageNamed:icon] forState:UIControlStateHighlighted];
            [self.stillCamera setFlashModel:flash];
            [self.stillCamera setTorchModel:torch];
        }];
        [self.ratioSuspensionView hide];
        [self.flashSuspensionView toggleBelowInView:self.view touchView:flashBtn];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @iUstrongify(self)
        [self.stillCamera setFlashModel:self.currentFlashModel];
        [self.stillCamera setTorchModel:self.currentTorchModel];
    }];
    
    // 比例按钮
    UIButton *scaleBtn = [[QMShakeButton alloc] initWithFrame:CGRectZero];
    [scaleBtn setTitle:@"3:4" forState:UIControlStateNormal];
    scaleBtn.titleLabel.font = [UIFont systemFontOfSize:8.0f];
    scaleBtn.layer.borderWidth = 1.1f;
    scaleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [topBg addSubview:scaleBtn];
    [scaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat x = self.view.frame.size.width/3;
        make.left.mas_equalTo(@(x));
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(0);
    }];
    [[scaleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        [self.ratioSuspensionView setRatioCallBack:^(QMSuspensionModel *item) {
            [self setCameraRatio:item.value];
            [scaleBtn setTitle:item.name forState:UIControlStateNormal];
        }];
        [self.flashSuspensionView hide];
        [self.ratioSuspensionView toggleBelowInView:self.view touchView:scaleBtn];
    }];
    
    // 设置按钮
    UIButton *settingBtn = [[QMShakeButton alloc] initWithFrame:CGRectZero];
    [settingBtn setImage:[AECResouce imageNamed:@"qmkit_setting_btn"] forState:UIControlStateNormal];
    [settingBtn setImage:[AECResouce imageNamed:@"qmkit_setting_btn"] forState:UIControlStateHighlighted];
    [topBg addSubview:settingBtn];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat x = self.view.frame.size.width/3;
        make.right.mas_equalTo(@(-x));
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    [[settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        QMCameraSettingViewController *settingVC = [[QMCameraSettingViewController alloc] init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    
    // 前后镜头
    UIButton *rotateBtn = [[QMShakeButton alloc] initWithFrame:CGRectZero];
    [rotateBtn setImage:[AECResouce imageNamed:@"qmkit_rotate_btn"] forState:UIControlStateNormal];
    [rotateBtn setImage:[AECResouce imageNamed:@"qmkit_rotate_btn"] forState:UIControlStateHighlighted];
    [topBg addSubview:rotateBtn];
    [rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.mas_offset(-20);
        make.centerY.mas_equalTo(0);
    }];
    [[rotateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        [self.stillCamera rotateCamera];
    }];
    
    // 底部背景
    UIView *bottomBg = [[UIView alloc] init];
    bottomBg.frame = CGRectMake(0,DSDeviceInfo.screenHeight-_cameraViewBottomBGHeight,DSDeviceInfo.screenWidth, _cameraViewBottomBGHeight);
    bottomBg.backgroundColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:255.0];
    [self.view addSubview:bottomBg];
    _bottomBg = bottomBg;
    
    // 拍照
    _takePhotoBtn = [[UIButton alloc] init];
    _takePhotoBtn.frame = CGRectMake(bottomBg.width/2-_cameraTakePhotoIconSize/2, _cameraViewBottomBGHeight/2-_cameraTakePhotoIconSize/2, _cameraTakePhotoIconSize, _cameraTakePhotoIconSize);
    [_takePhotoBtn setImage:[AECResouce imageNamed:@"qmkit_takephoto_btn"] forState:UIControlStateNormal];
    [_takePhotoBtn setImage:[AECResouce imageNamed:@"qmkit_takephoto_btn"] forState:UIControlStateHighlighted];
    [bottomBg addSubview:_takePhotoBtn];
    [[_takePhotoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        self.takePhotoBtn.userInteractionEnabled = NO;
        [self stopCameraCapture];
    }];
    
    // 相册选择
    CGFloat picBtnWidth = 25; CGFloat picBtnHeight = 30;
    CGFloat picBtnX = bottomBg.width/2 - _cameraTakePhotoIconSize/2;
    UIButton *picBtn = [[QMShakeButton alloc] init];
    picBtn.frame = CGRectMake(picBtnX/2-picBtnWidth/2, _cameraViewBottomBGHeight/2-picBtnWidth/2, picBtnWidth, picBtnHeight);
    picBtn.layer.borderWidth = 1.3f;
    picBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [bottomBg addSubview:picBtn];
    _picBtn = picBtn;
    [[picBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        [self choseImageFromPhotoLibrary];
    }];
    
    // 滤镜
    CGFloat filterSize = 35;
    CGFloat filterX = bottomBg.width/2 - _cameraTakePhotoIconSize/2;
    UIButton *filterBtn = [[QMShakeButton alloc] init];
    filterBtn.frame = CGRectMake(bottomBg.width-filterX/2-filterSize/2, _cameraViewBottomBGHeight/2-filterSize/2, filterSize, filterSize);
    [filterBtn setImage:[AECResouce imageNamed:@"qmkit_fiter_btn"] forState:UIControlStateNormal];
    [filterBtn setImage:[AECResouce imageNamed:@"qmkit_fiter_btn"] forState:UIControlStateHighlighted];
    [bottomBg addSubview:filterBtn];
    [[filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @iUstrongify(self)
        [self.cameraFilterView toggleInView:self.view];
    }];
    
    // 点击滤镜
    [self.cameraFilterView setFilterItemClickBlock:^(QMFilterModel *item, NSInteger index) {
        @iUstrongify(self)
        self.currentSwipeFilterIndex = index;
        [self.stillCamera removeAllTargets];
        self.filter = [[QMImageFilter alloc] initWithFilterModel:item];
        [(QMImageFilter *)self.filter setAlpha:item.currentAlphaValue];
        [self.stillCamera addTarget:self->_filter];
        [self.filter addTarget:self->_imageView];
    }];
    
    // 滤镜变化
    [self.cameraFilterView setFilterValueDidChangeBlock:^(CGFloat value) {
        @iUstrongify(self)
        QMImageFilter *filter = (QMImageFilter *)self.filter;
        [filter setAlpha:value];
    }];

    // 滤镜显示回调
    [self.cameraFilterView setFilterWillShowBlock:^{
        @iUstrongify(self)
        // 先缩放
        [UIView animateWithDuration:0.3f animations:^{
            picBtn.alpha = 0.0f;
            filterBtn.alpha = 0.0f;
            self.takePhotoBtn.frame = CGRectMake(DSDeviceInfo.screenWidth/2 - self->_cameraTakePhotoIconSize/4, DSDeviceInfo.screenHeight - self->_cameraViewBottomBGHeight/2 - self->_cameraTakePhotoIconSize/4, self->_cameraTakePhotoIconSize/2, self->_cameraTakePhotoIconSize/2);
        } completion:^(BOOL finished) {
            // 再移动
            [UIView animateWithDuration:0.1f animations:^{
                self.takePhotoBtn.frame = CGRectMake(DSDeviceInfo.screenWidth/2 - self->_cameraTakePhotoIconSize/4, DSDeviceInfo.screenHeight - (self->_cameraViewBottomBGHeight - 84)/2 - self->_cameraTakePhotoIconSize/4, self->_cameraTakePhotoIconSize/2, self->_cameraTakePhotoIconSize/2);
            } completion:^(BOOL finished) {
                // 最后交换层顺序
                [self.view bringSubviewToFront:self.takePhotoBtn];
            }];
        }];
    }];
    
    // 滤镜关闭回调
    [self.cameraFilterView setFilterWillHideBlock:^{
        @iUstrongify(self)
        // 交换层顺序
        [self.takePhotoBtn removeFromSuperview];
        [self.view insertSubview:self.takePhotoBtn belowSubview:[self cameraFilterView]];
        // 先回到原来位置
        [UIView animateWithDuration:0.2f animations:^{
            self.takePhotoBtn.frame = CGRectMake(DSDeviceInfo.screenWidth/2 - self->_cameraTakePhotoIconSize/4, DSDeviceInfo.screenHeight - self->_cameraViewBottomBGHeight/2 - self->_cameraTakePhotoIconSize/4, self->_cameraTakePhotoIconSize/2, self->_cameraTakePhotoIconSize/2);
        } completion:^(BOOL finished) {
            // 再放大
            [UIView animateWithDuration:0.3f animations:^{
                picBtn.alpha = 1.0f;
                filterBtn.alpha = 1.0f;
                self.takePhotoBtn.frame = CGRectMake(DSDeviceInfo.screenWidth/2 - self->_cameraTakePhotoIconSize/2, DSDeviceInfo.screenHeight - self->_cameraViewBottomBGHeight/2 - self->_cameraTakePhotoIconSize/2, self->_cameraTakePhotoIconSize, self->_cameraTakePhotoIconSize);
            }];
        }];
    }];
}

- (void)setupCamera
{
    // 初始化stillCamera
    _stillCamera = [[CKStillCamera alloc] init];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    // 初始化滤镜
    _filter = [[GPUImageCropFilter alloc] init];
    [_stillCamera addTarget:_filter];
    [_filter addTarget:_imageView];

    @iUweakify(self)
    [self.stillCamera setISOAdjustingBlock:^(BOOL adjust) {
        @iUstrongify(self)
        if (!adjust) {
            [self.cameraFocusView setISO:self.stillCamera.currentISOPercentage];
        }
    }];
}

#pragma mark - PrivateMethod
- (void)startCameraCapture
{
    runAsynchronouslyOnVideoProcessingQueue(^{
        [self.stillCamera setFlashModel:self.currentFlashModel];
        [self.stillCamera setTorchModel:self.currentTorchModel];
        [self.stillCamera setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        [self.stillCamera setExposeModel:AVCaptureExposureModeContinuousAutoExposure];
        [self.stillCamera startCameraCapture];
        dispatch_async(dispatch_get_main_queue(), ^{
           self.takePhotoBtn.userInteractionEnabled = YES;
        });
    });
}

- (void)stopCameraCapture
{
    @iUweakify(self)
    runAsynchronouslyOnVideoProcessingQueue(^{
        [self->_stillCamera capturePhotoAsImageProcessedUpToFilter:self->_filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            @iUstrongify(self)
            [self.stillCamera stopCameraCapture];
            UIImage *image = [UIImage clipImage: [processedImage fixOrientation] withRatio:self->_currentCameraViewRatio];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.takePhotoBtn.userInteractionEnabled = YES;
                QMPhotoDisplayViewController *displayVC = [[QMPhotoDisplayViewController alloc] init];
                displayVC.image = image;
                [self.navigationController pushViewController:displayVC animated:YES];
            });
        }];
        
    });
}

- (void)choseImageFromPhotoLibrary
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.autoDismiss = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)asyncLoadLatestImageFromPhotoLib
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [PHAsset latestImageWithSize:CGSizeMake(30, 30) completeBlock:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_picBtn setImage:image forState:UIControlStateNormal];
                [self->_picBtn setImage:image forState:UIControlStateHighlighted];
            });
        }];
    });
}

#pragma mark - 方向矫正
- (void)fixImageOrientation:(UIImage *)image completionBlock:(void(^)(UIImage *image))block
{
    [QMProgressHUD show];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *newImage = [image fixOrientation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMProgressHUD hide];
            if (block) {
                block(newImage);
            }
        });
    });
}

#pragma mark - 调整相机比例
- (void)setCameraRatio:(CGFloat)ratio
{
    _currentCameraViewRatio = ratio;
    float vaW = DSDeviceInfo.screenWidth;
    float vaH = DSDeviceInfo.screenWidth*4.0/3.0;
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

#pragma mark - Getter
- (QMCameraRatioSuspensionView *)ratioSuspensionView
{
    if (!_ratioSuspensionView) {
        _ratioSuspensionView = [QMCameraRatioSuspensionView ratioSuspensionView];
    }
    return _ratioSuspensionView;
}

- (QMCameraFlashSuspensionView *)flashSuspensionView
{
    if (!_flashSuspensionView) {
        _flashSuspensionView = [QMCameraFlashSuspensionView flashSuspensionView];
    }
    return _flashSuspensionView;
}

- (QMCameraFilterView *)cameraFilterView
{
    if (!_cameraFilterView) {
        _cameraFilterView = [QMCameraFilterView cameraFilterView];
    }
    return _cameraFilterView;
}

- (QMCameraFocusView *)cameraFocusView
{
    if (!_foucusView) {
        @iUweakify(self)
        _foucusView = [QMCameraFocusView focusView];
        [self.view addSubview:_foucusView];
        [_foucusView setLuminanceChangeBlock:^(CGFloat value) {
            @iUstrongify(self)
            [self.stillCamera setExposureModeCustomWithDuration:kCMTimeZero ISO:value completionHandler:NULL];
        }];
    }
    return _foucusView;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didSelectAsset:(PHAsset *)asset photo:(UIImage *)photo isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
        TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:photo];
        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetOriginal;
        cropViewController.delegate = self;
        [picker pushViewController:cropViewController animated:YES];
    }];
}


#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self fixImageOrientation:image completionBlock:^(UIImage *image) {
        QMPhotoEffectViewController *photoViewController = [[QMPhotoEffectViewController alloc] initWithImage:image];
        [cropViewController.navigationController pushViewController:photoViewController animated:YES];
    }];
}

@end
