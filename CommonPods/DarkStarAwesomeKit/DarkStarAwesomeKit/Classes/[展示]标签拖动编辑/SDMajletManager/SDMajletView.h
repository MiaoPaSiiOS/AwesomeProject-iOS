
#pragma mark - 杉德子件View
#import <UIKit/UIKit.h>
#import "SDMajletViewCollectionViewFlowLayout.h"
#import "SDMajletCollectionView.h"
typedef void(^SDMajletBlock)(BOOL isEdit);
@interface SDMajletView : UIView
@property (nonatomic, strong) SDMajletCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL editing;

/**
 回调block
 */
@property (nonatomic, copy)SDMajletBlock block;



@property(nonatomic, copy) void (^didSelectItemAtIndexPath)(NSIndexPath *indexPath);
/**
 初始化
 
 @param frame frame
 @return SDMajletView实例
 */
- (instancetype)initWithFrame:(CGRect)frame;



/**
 回调方法返回上下数组

 @param block 代码块
 */
- (void)callBacktitlesBlock:(SDMajletBlock)block;

-(void)reloadCollection;

@end
