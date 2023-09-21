//
//  CKCamera.h
//  EnjoyCamera
//
//  Created by qinmin on 2016/10/9.
//  Copyright © 2016年 qinmin. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface CKStillCamera : GPUImageStillCamera
@property(nullable, nonatomic, copy) void(^ISOChangeBlock)(float ISO);
@property(nullable, nonatomic, copy) void(^ISOAdjustingBlock)(BOOL adjust);
@property(nullable, nonatomic, copy) void(^FocusAdjustingBlock)(BOOL adjust);

// Focus
/// 是否允许设置焦点
- (BOOL)isFocusPointOfInterestSupported;

/// 设置焦点
/// @param point <#point description#>
- (void)focusAtPoint:(CGPoint)point;

/// 设置对焦模式
/// @param focusModel <#focusModel description#>
- (void)setFocusModel:(AVCaptureFocusMode)focusModel;

/// 自动对焦的范围是否有限制
- (BOOL)isAutoFocusRangeRestrictionSupported;

/// 设置自动对焦的范围
/// @param autoFocusModel <#autoFocusModel description#>
- (void)setAutoFocusRangeRestrictionModel:(AVCaptureAutoFocusRangeRestriction)autoFocusModel;

/// 是否支持平滑对焦
- (BOOL)isSmoothAutoFocusSupported;

/// 设置是否允许平滑对焦
/// @param enable <#enable description#>
- (void)enableSmoothAutoFocus:(BOOL)enable;

// Exposure
/// 是否支持感兴趣的曝光点调节
- (BOOL)isExposurePointOfInterestSupported;

/// 设置曝光模式
/// @param exposeModel <#exposeModel description#>
- (void)setExposeModel:(AVCaptureExposureMode)exposeModel;

/// 设置感兴趣的曝光点
/// @param point <#point description#>
- (void)exposeAtPoint:(CGPoint)point;

/// 曝光的偏移量
- (float)exposureTargetOffset;

/// 当前ISO(感光度)百分比
- (CGFloat)currentISOPercentage;

/// 手动模式下的设置曝光时间
/// @param duration <#duration description#>
/// @param ISO <#ISO description#>
/// @param handler <#handler description#>
- (void)setExposureModeCustomWithDuration:(CMTime)duration ISO:(float)ISO completionHandler:(nullable void (^)(CMTime syncTime))handler;

// Flash
/// 闪光灯模式
- (AVCaptureFlashMode)currentFlashModel;
- (void)setFlashModel:(AVCaptureFlashMode)flashModel;

// WhiteBalance
/// 白平衡模式
- (AVCaptureWhiteBalanceMode)currentWhiteBalanceMode;
- (void)setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode;

// Torch
/// 手电筒模式
- (AVCaptureTorchMode)currentTorchModel;
- (void)setTorchModel:(AVCaptureTorchMode)torchModel;
- (void)setTorchLevel:(float)torchLevel;
/*
 我们在自定义相机时，若要实现镜头变焦，也就是推近或者拉远焦距，有两种方法可以实现：
 1.可以通过修改AVCaptureDevice的缩放系数videoZoomFactor来实现镜头变焦，
 2.也可以通过修改AVCaptureConnection的缩放系数videoScaleAndCropFactor来实现镜头变焦。
 */
// Zoom
- (BOOL)videoCanZoom;
- (float)videoZoomFactor;
- (float)videoMaxZoomFactor;
- (void)setVideoZoomFactor:(float)factor;
- (void)rampZoomToFactor:(float)factor;
@end
