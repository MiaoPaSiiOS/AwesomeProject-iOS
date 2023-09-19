//
//  DSControl.h
//  YYKitExample
//
//  Created by ibireme on 15/9/14.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGestureRecognizer.h"

@interface DSControl : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void (^touchBlock)(DSControl *view, DSGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(DSControl *view, CGPoint point);
@end
