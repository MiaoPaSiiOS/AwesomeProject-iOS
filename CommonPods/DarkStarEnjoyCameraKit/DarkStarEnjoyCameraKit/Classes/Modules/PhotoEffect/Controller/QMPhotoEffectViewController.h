//
//  QMPhotoEffectViewController.h
//  EnjoyCamera
//
//  Created by qinmin on 2017/4/26.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "QMBaseViewController.h"

@interface QMPhotoEffectViewController : QMBaseViewController
@property (nonatomic, strong) UIImage *image;
- (instancetype)initWithImage:(UIImage *)image;
@end
