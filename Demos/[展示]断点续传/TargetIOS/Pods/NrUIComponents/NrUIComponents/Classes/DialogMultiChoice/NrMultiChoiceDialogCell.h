

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN
@class NrMultiChoiceDialog;
@interface NrMultiChoiceDialogCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIView *bLine;
@property (nonatomic, strong) id data;
@property (nonatomic, weak) NrMultiChoiceDialog *dialog;

- (void)setupCell;
- (void)buildSubview;
- (void)loadContent;
@end

NS_ASSUME_NONNULL_END
