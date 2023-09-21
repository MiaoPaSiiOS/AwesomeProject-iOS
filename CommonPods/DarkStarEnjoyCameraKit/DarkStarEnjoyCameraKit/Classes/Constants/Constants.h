//
//  Constants.h
//  EnjoyCamera
//
//  Created by qinmin on 2017/4/13.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <DarkStarGeneralTools/DarkStarGeneralTools.h>

#import <GPUImage/GPUImage.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <TOCropViewController/TOCropViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import "AECResouce.h"

// 裁剪比例
typedef enum {
    QMRatioTypeNone = 1,
    QMRatioType11,
    QMRatioType32,
    QMRatioType43,
    QMRatioType54,
    QMRatioType75,
    QMRatioType169,
    QMRatioTypeHorizontal,
    QMRatioTypeVertical,
    QMRatioTypeRotate,
    QMRatioTypeFree
} QMRatioType;

// 闪关灯类型
typedef enum {
    QMFlashTypeNone = 1,
    QMFlashTypeAuto,
    QMFlashTypeAlways,
    QMFlashTypeTorch
} QMFlashType;



#endif /* Constants_h */

