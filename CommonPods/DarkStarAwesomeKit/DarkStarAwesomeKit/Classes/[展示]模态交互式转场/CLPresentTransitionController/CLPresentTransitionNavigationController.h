//
//  CLPresentTransitionNavigationController.h
//  CLDemo
//
//  Created by AUG on 2019/7/19.
//  Copyright © 2019 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTransitionEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLPresentTransitionNavigationController : UINavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController presentDirection:(CLInteractiveCoverDirection)presentDirection dissmissDirection:(CLInteractiveCoverDirection)dissmissDirection;

@end

NS_ASSUME_NONNULL_END
