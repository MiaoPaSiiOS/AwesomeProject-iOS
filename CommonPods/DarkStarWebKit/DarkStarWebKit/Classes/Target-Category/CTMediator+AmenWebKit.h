//
//  CTMediator+AmenWebKit.h
//  Amen
//
//  Created by zhuyuhui on 2022/7/1.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (AmenWebKit)

- (void)mediator_pushWebViewController:(nullable NSDictionary *)params ;
- (void)mediator_pushWebViewDemoController:(nullable NSDictionary *)params ;
@end

NS_ASSUME_NONNULL_END
