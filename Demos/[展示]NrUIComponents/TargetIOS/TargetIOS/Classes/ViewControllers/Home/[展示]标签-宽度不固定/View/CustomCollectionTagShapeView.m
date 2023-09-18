//
//  CustomCollectionTagShapeView.m
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/6/17.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import "CustomCollectionTagShapeView.h"

@implementation CustomCollectionTagShapeView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderLayer = [CAShapeLayer layer];
        self.borderLayer.name = @"borderLayer";
        self.borderLayer.fillColor = [UIColor clearColor].CGColor;
        self.borderLayer.strokeColor = [UIColor greenColor].CGColor;
        [((CAShapeLayer *)self.layer) addSublayer:self.borderLayer];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.corners cornerRadii:self.cornerRadii];
    ((CAShapeLayer *)self.layer).path = maskPath.CGPath;
    
    ///2、设置border
    for (CALayer *layer in ((CAShapeLayer *)self.layer).sublayers) {
        if ([layer.name isEqualToString:@"borderLayer"]) {
            ((CAShapeLayer *)layer).path = maskPath.CGPath;
            ((CAShapeLayer *)layer).frame = self.bounds;
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    ((CAShapeLayer *)self.layer).fillColor = backgroundColor.CGColor;
}

@end
