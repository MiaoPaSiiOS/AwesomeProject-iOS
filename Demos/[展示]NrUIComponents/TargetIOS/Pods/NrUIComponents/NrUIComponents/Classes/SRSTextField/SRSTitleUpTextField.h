
#import "SRSTextField.h"

NS_ASSUME_NONNULL_BEGIN



@interface SRSTitleUpTextField : SRSTextField <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *lineLabel;

/// 标题 正常标题
@property (nonatomic, strong) NSString *title;
/// 标题 报错标题
@property (nonatomic, strong) NSString *errorTitle;



@end

NS_ASSUME_NONNULL_END
