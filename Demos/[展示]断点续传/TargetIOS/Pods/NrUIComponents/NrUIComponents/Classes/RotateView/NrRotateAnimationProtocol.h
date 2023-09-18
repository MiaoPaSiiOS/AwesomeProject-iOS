//
//  NrRotateAnimationProtocol.h
//  Pods
//
//  Created by zhuyuhui on 2020/9/17.
//

#import <Foundation/Foundation.h>
#import "UIView+NrRotateAnimationProtocol.h"

@protocol NrRotateAnimationProtocol <NSObject>

/**
 *  Rotate to up (default).
 *
 *  @param animated Animated or not.
 */
- (void)changeToUpAnimated:(BOOL)animated;

/**
 *  Rotate to left.
 *
 *  @param animated Animated or not.
 */
- (void)changeToLeftAnimated:(BOOL)animated;

/**
 *  Rotate to right.
 *
 *  @param animated Animated or not.
 */
- (void)changeToRightAnimated:(BOOL)animated;

/**
 *  Rotate to down.
 *
 *  @param animated Animated or not.
 */
- (void)changeToDownAnimated:(BOOL)animated;

@end

