
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <NrBaseCoreKit/NrBaseCoreKit.h>
#import "SRSAutoLayoutScrollView.h"
/**
 浮层容器
 */
NS_ASSUME_NONNULL_BEGIN

typedef void(^SRSFloatDismissBlock)(void);

typedef NS_ENUM(NSInteger, SRSFloatElementViewType) {
    /// 1、居中浮层宽度固定600px，高度视具体内容而定，最大高度890px，超出高度部分上下滑动。
    /// 2、关闭按钮在浮层右上角
    /// 3、点击关闭按钮或者浮层以外的lightbox区域后渐出的关闭浮层回到当前页面
    SRSFloatElementViewTypeDefault = 0,
    /// 位置、操作等具体由shadowEdges、floatEdges、isOutDismiss、isCloseButtonNeeded决定
    SRSFloatElementViewTypeCustom
};

@interface SRSFloatElementView : UIView

@property (nonatomic) CGFloat floatWindowMaxHeight; //default is 445. 自动kAutoScale
@property (nonatomic, assign) UIEdgeInsets shadowEdges; // default UIEdgeInsetsZero 自动kAutoScale
@property (nonatomic, assign) UIEdgeInsets floatEdges; // default UIEdgeInsetsMake(267, 0, 0, 0) 自动kAutoScale
@property (nonatomic, assign) BOOL isOutDismiss; // default YES
@property (nonatomic, assign) BOOL isCloseButtonNeeded; // default YES
@property (nonatomic, copy) SRSFloatDismissBlock dismissBlock;
@property (nonatomic, assign, readonly) SRSFloatElementViewType type; // default SRSFloatElementViewTypeDefault
@property (nonatomic, strong, readonly) SRSAutoLayoutScrollView *scrollView;
@property (nonatomic, strong, readonly) UIButton *dismissButton;

- (instancetype)initWithType:(SRSFloatElementViewType)type;
- (void)show;
- (void)showIn:(UIView *)superView;
- (void)appendSubView:(UIView *)subView;
@end

NS_ASSUME_NONNULL_END
