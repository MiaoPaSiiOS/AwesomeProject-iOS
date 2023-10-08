

#import <UIKit/UIKit.h>

typedef void(^EditAction)(BOOL isEdit);
@interface SDMajletCellHead : UICollectionReusableView
@property (nonatomic, strong) NSString *title;
//@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UILabel *subTItleLab;
@property (nonatomic, copy)   EditAction editBlock;
@end
