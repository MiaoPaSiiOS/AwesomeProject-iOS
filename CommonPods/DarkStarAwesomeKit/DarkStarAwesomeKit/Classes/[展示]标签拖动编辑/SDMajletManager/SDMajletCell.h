
#import <UIKit/UIKit.h>

@interface SDMajletCell : UICollectionViewCell


/**
 是否在移动
 */
@property (nonatomic, assign) BOOL isMoving;


/**
 icon名
 */
@property (nonatomic, strong) NSString *iconName;


/**
 标题
 */
@property (nonatomic, strong) NSString *title;


@property (nonatomic, assign) CGFloat font;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *editImgView;

@end
