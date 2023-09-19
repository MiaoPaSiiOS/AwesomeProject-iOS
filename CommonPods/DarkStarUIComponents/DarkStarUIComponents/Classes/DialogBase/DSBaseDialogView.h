#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface DSBaseDialogView : UIView
#pragma mark - 视图容器
@property (nonatomic, strong, readonly) UIView   *container;
@property (nonatomic, strong, readonly) UIButton *background;

#pragma mark - 参数
@property(nonatomic, assign) NSInteger dialogTag;
@property(nonatomic, strong, nullable) id info;
@property(nonatomic, strong, nullable) id picker;
@property(nonatomic, strong, nullable) id selectedItem;// 选中内容,可能是数组,可能是一个对象
@property(nonatomic, strong, nullable) NSArray *showDatas;// 显示内容的数据
@property(nonatomic, weak,   nullable) id object;// weak对象

#pragma mark - 回调
@property(nonatomic, copy) void (^dialogWillShow)(DSBaseDialogView *dialog);
@property(nonatomic, copy) void (^dialogDidShow)(DSBaseDialogView *dialog);
@property(nonatomic, copy) void (^dialogWillHide)(DSBaseDialogView *dialog);
@property(nonatomic, copy) void (^dialogDidHide)(DSBaseDialogView *dialog);


/// 子类重写 ： 1.添加视图到container 2.数据赋值
- (void)setupView;
- (void)showInView:(UIView *)superiorView;
- (void)dismisView;
@end

NS_ASSUME_NONNULL_END
