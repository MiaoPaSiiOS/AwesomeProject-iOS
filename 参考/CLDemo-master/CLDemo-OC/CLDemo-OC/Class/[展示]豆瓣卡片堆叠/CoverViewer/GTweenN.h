//
//  GTweenN.h
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/2/25.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    GTweenNStatusNoStart,
    GTweenNStatusPlayForword,
    GTweenNStatusPlayBackword,
    GTweenNStatusPaused,
    GTweenNStatusStop
} GTweenNStatus;

@interface GTweenN : NSObject
@property(nonatomic, assign, readonly) GTweenNStatus status;
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) CGFloat fromValue;
@property(nonatomic, assign) CGFloat toValue;
- (void)start;
@end

NS_ASSUME_NONNULL_END
