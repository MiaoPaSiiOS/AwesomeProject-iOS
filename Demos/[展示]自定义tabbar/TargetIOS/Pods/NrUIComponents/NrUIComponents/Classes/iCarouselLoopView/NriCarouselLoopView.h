
#import <UIKit/UIKit.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>
#import <iCarousel/iCarousel.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
NS_ASSUME_NONNULL_BEGIN

@class NriCarouselLoopView;

@protocol NriCarouselLoopViewDelegate <NSObject>

@optional

/// 自定义图片样式
/// @param index 下标
/// @param imageView imageView
- (void)customViewForItemAtIndex:(NSInteger)index reusingView:(UIImageView *)imageView;

/** 点击图片回调 */
- (void)bannerView:(NriCarouselLoopView *)bannerView didSelectItemAtIndex:(NSInteger)index;

@end

@interface NriCarouselLoopView : UIView

@property (nonatomic, weak) id<NriCarouselLoopViewDelegate> delegate;

/** 自动滚动间隔时间,默认3s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic, assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic, assign) BOOL autoScroll;

/** 图片的大小*/
@property (nonatomic, assign) CGSize itemSize;

/** 图片之间间距*/
@property (nonatomic, assign) CGFloat itemSpace;

/** 占位图片*/
@property (nonatomic, strong) UIImage *defaultImage;

/** 界管数据设置轮播*/
- (void)configureWithModel:(NSArray *)urls;

- (void)setCanScroll:(BOOL)canScroll;

@end

NS_ASSUME_NONNULL_END
