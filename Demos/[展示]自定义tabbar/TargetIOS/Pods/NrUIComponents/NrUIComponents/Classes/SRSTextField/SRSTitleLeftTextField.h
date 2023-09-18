
#import "SRSTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRSTitleLeftTextField : SRSTextField

/// 不可以直接设置titleLabel.text， 只能使用title设置
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

/// 标题 ，不设置默认没有
@property (nonatomic, strong) NSString *title;


@end

NS_ASSUME_NONNULL_END
