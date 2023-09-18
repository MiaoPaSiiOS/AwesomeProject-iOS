//
//  CLPresentTransitionController.h
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <DarkStarUIKit/DarkStarUIKit.h>
#import "CLTransitionEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLPresentTransitionController : DSViewController

- (instancetype)initWithPresentDirection:(CLInteractiveCoverDirection)presentDirection dissmissDirection:(CLInteractiveCoverDirection)dissmissDirection;


@end

NS_ASSUME_NONNULL_END
