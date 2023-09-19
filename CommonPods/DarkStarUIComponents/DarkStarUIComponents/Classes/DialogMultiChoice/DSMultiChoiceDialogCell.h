

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN
@class DSMultiChoiceDialog;
@interface DSMultiChoiceDialogCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIView *bLine;
@property (nonatomic, strong) id data;
@property (nonatomic, weak) DSMultiChoiceDialog *dialog;

- (void)setupCell;
- (void)buildSubview;
- (void)loadContent;
@end

NS_ASSUME_NONNULL_END
