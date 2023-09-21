//
//  QMPhotoEffectViewController.m
//  EnjoyCamera
//
//  Created by qinmin on 2017/4/26.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMPhotoEffectViewController.h"
#import <Photos/Photos.h>
#import "QMImageFilter.h"
#import "QMFilterThemeView.h"
#import "QMShareManager.h"
#import "QMCropThemeView.h"
#import "QMCropModel.h"
#import "QMProgressHUD.h"
#import "QMFrameThemeView.h"
#import "QMDragView.h"
#import "QMBaseImageView.h"
#import "TKImageView.h"
#import "UIImage+SubImage.h"
#import "UIImage+Rotate.h"
#import "UIImage+Clip.h"
#import "Constants.h"
/**************标签*************/
#define kIconButtonTagBack      1
#define kIconButtonTagOrigin    2
#define kIconButtonTagShare     3
#define kIconButtonTagFilter    4
#define kIconButtonTagCrop      5
#define kIconButtonTagFrame     6
#define kIconButtonTagSave      7

@interface QMPhotoEffectViewController ()
@property (nonatomic, strong) GPUImageFilter *filter;

@property (nonatomic, strong) UIView *imageViewHodler;
@property (nonatomic, strong) QMBaseImageView *imageView;

@property (nonatomic, strong) GPUImagePicture *picture;
@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, strong) QMFilterThemeView *filterThemeView;
@property (nonatomic, strong) NSArray<QMFilterModel *> *filterModels;

@property (nonatomic, strong) TKImageView *cropView;
@property (nonatomic, strong) QMCropThemeView *cropThemeView;

@property (nonatomic, strong) QMFrameThemeView *frameThemeView;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;

@end

@implementation QMPhotoEffectViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _originImage = image;
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupGPUPicture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect topBarFrame   = self.topBar.frame;
    CGRect bottomBarFrame   = self.bottomBar.frame;
    if (@available(iOS 11.0, *)) {
        topBarFrame.origin.y = self.view.safeAreaInsets.top;
        bottomBarFrame.origin.y = self.view.frame.size.height - bottomBarFrame.size.height - self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    self.topBar.frame = topBarFrame;
    self.bottomBar.frame = bottomBarFrame;

}

#pragma mark - SETUP
- (void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.12f alpha:1.0f];
    
    // GPUImageViewHodler
    _imageViewHodler = [[UIView alloc] initWithFrame:self.view.bounds];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDragViewBorder:)];
    [_imageViewHodler addGestureRecognizer:gesture];
    [self.view addSubview:_imageViewHodler];
    
    // UImageView
    _imageView = [[QMBaseImageView alloc] initWithFrame:CGRectMake(30, 70, self.view.frame.size.width-60, self.view.frame.size.height-140)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = _image;
    _imageView.backgroundColor = [UIColor colorWithRed:0.12f green:0.12f blue:0.12f alpha:1.0];
    [self.imageViewHodler addSubview:_imageView];
    
    // CropView
    _cropView = [[TKImageView alloc] initWithFrame:CGRectMake(30, 70, self.view.frame.size.width-58, self.view.frame.size.height-140)];
    _cropView.toCropImage = _image;
    _cropView.showMidLines = YES;
    _cropView.needScaleCrop = YES;
    _cropView.showCrossLines = YES;
    _cropView.cornerBorderInImage = NO;
    _cropView.cropAreaCornerWidth = 44;
    _cropView.cropAreaCornerHeight = 44;
    _cropView.minSpace = 30;
    _cropView.cropAreaCornerLineColor = [UIColor whiteColor];
    _cropView.cropAreaBorderLineColor = [UIColor whiteColor];
    _cropView.cropAreaCornerLineWidth = 4;
    _cropView.cropAreaBorderLineWidth = 2;
    _cropView.cropAreaMidLineWidth = 1;
    _cropView.cropAreaMidLineHeight = 1;
    _cropView.cropAreaMidLineColor = [UIColor whiteColor];
    _cropView.cropAreaCrossLineColor = [UIColor whiteColor];
    _cropView.cropAreaCrossLineWidth = 1;
    _cropView.initialScaleFactor = .8f;
    _cropView.cropAspectRatio = 1.0f;
    [_cropView hide];
    [self.view addSubview:_cropView];



    // TopBar
    [self.view addSubview:self.topBar];
    // BottomBar
    [self.view addSubview:self.bottomBar];
}

- (void)setupGPUPicture
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self->_picture = [[GPUImagePicture alloc] initWithImage:self->_image];
    });
}

#pragma mark - 滤镜
- (QMFilterThemeView *)filterThemeView
{
    // FilterThemeView
    if (!_filterThemeView) {
        _filterThemeView = [[QMFilterThemeView alloc] init];
        [self.view addSubview:_filterThemeView];
        
        __weak typeof(self) wself = self;
        [self.filterThemeView setFilterClickBlock:^(QMFilterModel *model) {
            [wself changeFilter:model];
        }];
        
        [self.filterThemeView setSliderValueChangeBlock:^(NSInteger index, float value) {
            [wself changeFilterAlpha:@(value)];
        }];
        
        // load Res
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *dirPath = [AECResouce Filters].bundlePath;
            self->_filterModels = [QMFilterModel buildFilterModelsWithPath:dirPath];
            [self.filterThemeView setFilterModels:self->_filterModels];
            dispatch_async(dispatch_get_main_queue(), ^{
                // filterThemeView
                [self.filterThemeView reloadData];
            });
        });
    }
    
    return _filterThemeView;
}

#pragma mark - 裁剪
- (QMCropThemeView *)cropThemeView
{
    if (!_cropThemeView) {
        // CropThemeView
        _cropThemeView = [[QMCropThemeView alloc] init];
        [self.view addSubview:_cropThemeView];
        
        self.cropThemeView.cropModels = [QMCropModel buildCropModels];
        [self.cropThemeView reloadData];
        
        __weak typeof(self) wself = self;
        [self.cropThemeView setDoneButtonClickBlock:^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [wself.cropView currentCroppedImage];
                [wself changeImage:image];
            });
        }];
        
        [self.cropThemeView setCloseButtonClickBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.cropView setHidden:YES];
                [wself.imageView setHidden:NO];
            });
        }];
        
        [self.cropThemeView setCroperClickBlock:^(CGSize aspect, CGFloat rotation) {
            if (rotation > 0.0f) {
                [wself.cropView rotate];
            }else {
                [wself.cropView setCropAspectRatio:aspect.width/aspect.height];
            }
        }];
    }
    
    return _cropThemeView;
}

#pragma mark - 相框
- (QMFrameThemeView *)frameThemeView
{
    if (!_frameThemeView) {
        // FrameThemeView
        _frameThemeView = [[QMFrameThemeView alloc] init];
        [self.view addSubview:_frameThemeView];
        
        [self.frameThemeView setFrameModels:[QMFrameModel buildFrameModels]];
        [self.frameThemeView reloadData];
        
        __weak typeof(self) wself = self;
        [self.frameThemeView setFrameClickBlock:^(QMFrameModel *model) {
            for (UIView *view in wself.imageViewHodler.subviews) {
                if ([view isKindOfClass:[QMDragView class]]) {
                    [(id)view hideToolBar];
                }
            }
            UIImage *img = [UIImage imageWithContentsOfFile:[[AECResouce Frames] URLForResource:model.icon withExtension:nil].path];
            QMDragView *iconView = [[QMDragView alloc] initWithFrame:wself.imageView.bounds image:img];

            [wself.imageViewHodler addSubview:iconView];
        }];
    }
    
    return _frameThemeView;
}

#pragma mark - Events
- (void)buttonTapped:(UIButton *)sender
{
    __weak __typeof(self)weakSelf = self;
    switch (sender.tag) {
        case kIconButtonTagBack:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case kIconButtonTagOrigin:
            [self restoreImage];
            break;
        case kIconButtonTagShare: {
            [self generateEffectedImageWithCompleteBlock:^(UIImage *image) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                dispatch_async(dispatch_get_main_queue(), ^{
                   [QMShareManager shareThumbImage:image inViewController:strongSelf];
                });
            }];
            
        }
            break;
        case kIconButtonTagFilter:
            [self.filterThemeView show];
            break;
        case kIconButtonTagCrop:
            [self.cropThemeView show];
            [self.cropView setToCropImage:self.imageView.image];
            [self.cropView show];
            self.imageView.hidden = YES;
            break;
        case kIconButtonTagFrame:
            [self.frameThemeView show];
            break;
        case kIconButtonTagSave:
            [self saveImage];
            break;
        default:
            break;
    }
}

#pragma mark - PrivateMethod
- (void)changeFilter:(QMFilterModel *)model
{
    [QMProgressHUD show];
    
    self.filter = [[QMImageFilter alloc] initWithFilterModel:model];
    [(QMImageFilter *)self.filter setAlpha:model.currentAlphaValue];
    
    [self.picture removeAllTargets];
    [self.picture addTarget:self.filter];
    [self.filter useNextFrameForImageCapture];
    
    __weak typeof(self) wself = self;
    [self.picture processImageWithCompletionHandler:^{
        UIImage *image = [wself.filter imageFromCurrentFramebuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.imageView.image = image;
            [QMProgressHUD hide];
        });
    }];
}

- (void)changeFilterAlpha:(NSNumber *)alpha
{
    [QMProgressHUD show];
    
    QMImageFilter *imageFilter = (QMImageFilter *)self.filter;
    [imageFilter setAlpha:[alpha floatValue]];
    [imageFilter useNextFrameForImageCapture];
    
    __weak typeof(self) wself = self;
    [self.picture processImageWithCompletionHandler:^{
        UIImage *image = [wself.filter imageFromCurrentFramebuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.imageView.image = image;
            [QMProgressHUD hide];
        });
    }];
}

- (void)changeImage:(UIImage *)image
{
    [QMProgressHUD show];
    
    self.image = image;
    self.picture = [[GPUImagePicture alloc] initWithImage:image];
    if (self.filter) {
        [self.picture addTarget:self.filter];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = self.image;
        [self.imageView setHidden:NO];
        [self.cropView hide];
        [QMProgressHUD hide];
    });
}

- (void)restoreImage
{
    [QMProgressHUD show];
    
    self.filter = nil;
    self.image = _originImage;
    self.imageView.image = self.image;
    self.cropView.toCropImage = self.image;
    
    self.picture = [[GPUImagePicture alloc] initWithImage:self.image];
    
    [QMProgressHUD hide];
}

- (void)saveImage
{
    [self generateEffectedImageWithCompleteBlock:^(UIImage *image) {
//        [UIImagePNGRepresentation(image) writeToFile:@"/Users/qinmin/Desktop/1.png" atomically:YES];
        [QMProgressHUD show];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            [QMProgressHUD hide];
        }];
    }];
}

- (void)hideDragViewBorder:(UITapGestureRecognizer *)gesture
{
    NSArray *subviews = [[self.imageViewHodler.subviews reverseObjectEnumerator] allObjects];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[QMDragView class]]) {
            QMDragView *dragView = (id)view;
            CGPoint location = [gesture locationInView:view];
            if (view.userInteractionEnabled && CGRectContainsPoint(dragView.imageView.frame, location)) {
                if ([(id)view isToolBarHidden]) {
                    [(id)view showToolBar];
                }else {
                    [(id)view hideToolBar];
                }
            }else {
                [(id)view hideToolBar];
            }
        }
    }
}

- (UIImage *)generateFrameOnImage:(UIImage *)image
{
    CGFloat scaleX  = self.imageView.frame.size.width/CGImageGetWidth(image.CGImage);
    CGFloat scaleY  = self.imageView.frame.size.height/CGImageGetHeight(image.CGImage);
    CGFloat scaleFactor = MIN(scaleX, scaleY);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    for (UIView *view in self.imageViewHodler.subviews) {
        if ([view isKindOfClass:[QMDragView class]]) {
            QMDragView *originView = (QMDragView *)view;
            QMDragView *dragView = [originView copyWithScaleFactor:scaleFactor relativedView:self.imageView];
            [dragView hideToolBar];
            [imageView addSubview:dragView];
        }
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [imageView.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)generateEffectedImageWithCompleteBlock:(void(^)(UIImage *))block;
{
    [QMProgressHUD show];
   
    if (self.filter) {
        __weak __typeof(self)weakSelf = self;
        [self.filter useNextFrameForImageCapture];
        [self.picture processImageWithCompletionHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *filterImage = [strongSelf.filter imageFromCurrentFramebuffer];
                UIImage *image = [strongSelf generateFrameOnImage:filterImage];
                if (block) {
                    block(image);
                }
                [QMProgressHUD hide];
            });
            
        }];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [self generateFrameOnImage:self.image];
            if (block) {
                block(image);
            }
            [QMProgressHUD hide];
        });
    }
}



#pragma mark - gettet
-(UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _bottomBar.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:255];

        // BottomSlide
        UIView *bottomSlide = [[UIView alloc] initWithFrame:CGRectZero];
        bottomSlide.backgroundColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:255];
        [_bottomBar addSubview:bottomSlide];
        [bottomSlide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.top.right.mas_equalTo(0);
        }];
        
        float width = [UIScreen mainScreen].bounds.size.width;

        // FilterButton
        UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [filterBtn setImage:[AECResouce imageNamed:@"qmkit_bar_filter_btn"] forState:UIControlStateNormal];
        [filterBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [filterBtn setTag:kIconButtonTagFilter];
        [_bottomBar addSubview:filterBtn];
        
        [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.left.mas_equalTo(width/8.0f-27/2.0f);
            make.centerY.mas_equalTo(0);
        }];
        
        // CropButton
        UIButton *cropBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [cropBtn setImage:[AECResouce imageNamed:@"qmkit_bar_crop_btn"] forState:UIControlStateNormal];
        [cropBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cropBtn setTag:kIconButtonTagCrop];
        [_bottomBar addSubview:cropBtn];
        [cropBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.left.mas_equalTo(width*3/8.0f-27/2.0);
            make.centerY.mas_equalTo(0);
        }];
        
        // BorderButton
        UIButton *borderBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [borderBtn setImage:[AECResouce imageNamed:@"qmkit_bar_border_btn"] forState:UIControlStateNormal];
        [borderBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [borderBtn setTag:kIconButtonTagFrame];
        [_bottomBar addSubview:borderBtn];
        [borderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.left.mas_equalTo(width*5/8.0f-27/2.0);
            make.centerY.mas_equalTo(0);
        }];
        
        // SaveButton
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [saveBtn setImage:[AECResouce imageNamed:@"qmkit_bar_save_btn"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTag:kIconButtonTagSave];
        [_bottomBar addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.left.mas_equalTo(width*7/8.0f-27/2.0);
            make.centerY.mas_equalTo(0);
        }];
    }
    return _bottomBar;
}

-(UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _topBar.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:255];

        
        // TopSlide
        UIView *topSlide = [[UIView alloc] initWithFrame:CGRectZero];
        topSlide.backgroundColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:255];
        [_topBar addSubview:topSlide];
        [topSlide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.bottom.right.mas_equalTo(0);
        }];
        
        
        // BackButton
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [backBtn setImage:[AECResouce imageNamed:@"qmkit_toolbar_back_btn"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setTag:kIconButtonTagBack];
        [_topBar addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        }];
        
        // OriginBtn
        UIButton *originBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [originBtn setImage:[AECResouce imageNamed:@"qmkit_toolbar_origin_btn"] forState:UIControlStateNormal];
        [originBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [originBtn setTag:kIconButtonTagOrigin];
        [_topBar addSubview:originBtn];
        [originBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        
        // ShareButton
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [shareBtn setImage:[AECResouce imageNamed:@"qmkit_toolbar_share_btn"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setTag:kIconButtonTagShare];
        [_topBar addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(22);
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(0);
        }];
        
        
    }
    return _topBar;
}
@end
