//
//  NrControl.h
//  YYKitExample
//
//  Created by ibireme on 15/9/14.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NrGestureRecognizer.h"

@interface NrControl : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) void (^touchBlock)(NrControl *view, NrGestureRecognizerState state, NSSet *touches, UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(NrControl *view, CGPoint point);
@end
