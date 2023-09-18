//
//  NrDownSheetView.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2022/7/8.
//

#import <UIKit/UIKit.h>

@class NrDownSheetView;

@protocol NrDownSheetViewDataSource <NSObject>
@required

- (UITableViewCell *)downSheetView:(NrDownSheetView *)downSheetView cellForIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)downSheetView:(NrDownSheetView *)downSheetView numberOfRowsInSection:(NSInteger)section;

@end

@protocol NrDownSheetViewDelegate <NSObject>

@optional
- (void)downSheetView:(NrDownSheetView *)downSheetView didSelectIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)downSheetView:(NrDownSheetView *)downSheetView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)downSheetLeftButtonClick:(UIButton *)button;
- (void)downSheetRightButtonClick:(UIButton *)button;
- (void)overlayViewDismiss;
@end


@interface NrDownSheetView : UIView
// 弹出动画方式
@property (nonatomic, strong) NSString *animated;
// 标题栏
@property (nonatomic, strong) UILabel *titleLabel;
// 标题
@property (nonatomic, strong) UIView *titleView;
// 左边 按钮
@property (nonatomic, strong) UIButton *leftButton;
// 右边 按钮
@property (nonatomic, strong) UIButton *rightButton;
// 展示列表
@property (nonatomic, strong) UITableView *listView;
// 代理
@property (nonatomic, weak) id<NrDownSheetViewDataSource> dataSource;
@property (nonatomic, weak) id<NrDownSheetViewDelegate>   delegate;

- (instancetype)initWithTitle:(NSString *)title leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle contentHeight:(CGFloat)height;
- (instancetype)initWithTitle:(NSString *)title leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage  contentHeight:(CGFloat)height;
- (void)showInViewController:(UIViewController *)viewController;
- (void)fadeOut;
@end

