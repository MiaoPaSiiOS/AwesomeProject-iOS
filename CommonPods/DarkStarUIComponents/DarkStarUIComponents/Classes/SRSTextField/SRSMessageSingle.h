
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, eSRSBottomLabelStatus) {
    eSRSBottomLabelStatusDefault = 0,
    eSRSBottomLabelStatusInput,
    eSRSBottomLabelStatusError,
};

@class SRSMessageSingle;

@protocol SRSMessageSingleDelegate <NSObject>

- (void)clickBtn:(SRSMessageSingle *)aView;

@end

@interface SRSMessageSingle : UIView

@property (nonatomic, weak) id <SRSMessageSingleDelegate> delegate;

/// 文字内容
@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, assign) eSRSBottomLabelStatus status;

- (void)startAnimatuon;
- (void)stopAnimaton;


@end

NS_ASSUME_NONNULL_END
