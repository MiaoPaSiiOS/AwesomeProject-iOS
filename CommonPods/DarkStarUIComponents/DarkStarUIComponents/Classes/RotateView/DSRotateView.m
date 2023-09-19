//
//  DSRotateView.m
//  Pods
//
//  Created by zhuyuhui on 2020/9/17.
//

#import "DSRotateView.h"

@implementation DSRotateView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.tmDefaultTransform = self.transform;
    }
    
    return self;
}

#pragma mark - 动画的执行
- (void)changeToUpAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:(self.tmRotateDuration > 0 ? self.tmRotateDuration : 0.5f)
                         animations:^{
                             
                             self.transform = self.tmDefaultTransform;
                         }];
    } else {
        
        self.transform = self.tmDefaultTransform;
    }
    
}
- (void)changeToLeftAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:(self.tmRotateDuration > 0 ? self.tmRotateDuration : 0.5f)
                         animations:^{
                             
                             self.transform = CGAffineTransformRotate(self.tmDefaultTransform, -M_PI_2);
                         }];
    } else {
        
        self.transform = CGAffineTransformRotate(self.tmDefaultTransform, -M_PI_2);
    }
}
- (void)changeToRightAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:(self.tmRotateDuration > 0 ? self.tmRotateDuration : 0.5f)
                         animations:^{
                             
                             self.transform = CGAffineTransformRotate(self.tmDefaultTransform, M_PI_2);
                         }];
    } else {
        
        self.transform = CGAffineTransformRotate(self.tmDefaultTransform, M_PI_2);
    }
}
- (void)changeToDownAnimated:(BOOL)animated {
    
    if (animated) {
        
        [UIView animateWithDuration:(self.tmRotateDuration > 0 ? self.tmRotateDuration : 0.5f)
                         animations:^{
                             
                             self.transform = CGAffineTransformRotate(self.tmDefaultTransform, M_PI);
                         }];
    } else {
        
        self.transform = CGAffineTransformRotate(self.tmDefaultTransform, M_PI);
    }
}

@end
