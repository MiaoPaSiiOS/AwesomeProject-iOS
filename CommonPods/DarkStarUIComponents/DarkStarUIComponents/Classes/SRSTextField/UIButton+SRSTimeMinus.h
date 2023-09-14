
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SRSTimeMinus)

/**
 *  开始倒计时
 */
- (void)start;

/**
 *  开始倒计时 time 倒计时开始时间，默认60
 */
- (void)startWithStartTime:(NSUInteger)time;

/**
 *  结束倒计时
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
