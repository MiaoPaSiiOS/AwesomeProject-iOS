
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Nr)
/** 获取和自身处于同一个UINavigationController里的上一个UIViewController */
@property(nullable, nonatomic, weak, readonly) UIViewController *nr_previousViewController;


@end

NS_ASSUME_NONNULL_END
