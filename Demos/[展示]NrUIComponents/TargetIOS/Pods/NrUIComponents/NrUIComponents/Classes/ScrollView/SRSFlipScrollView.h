//
//  SRSFlipScrollView.h
//  AmenUIKit
//
//  Created by zhuyuhui on 2021/12/21.
//
/*
 IOS开发之－－UIScrollView pagingEnabled自定义翻页宽度
 https://www.cnblogs.com/v-jing/p/3509219.html
 
 PagingEnabled只能翻过整页，下面几个简单的设置即可实现自定义翻页宽度

 技术点：

 1. 创建一个继承UIView的视图，并设置clipsToBounds＝ YES

 2. 添加一个UIscrollView控件，将其宽度设置为自定义翻页的宽度

 3. 设置UIScrollview 的clipsToBounds＝ NO

 4. 确保本View的宽度大于UIScrollView的宽度用于显示预览内容

 5. 重写本View的hittest方法，为了确保用户滑动UIscrollview以外的空间时也可以触发UIscrollview滑动

 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRSFlipScrollView : UIView
@property(nonatomic, strong) UIScrollView *scrollView;

/// 初始化
/// @param frame frame description
/// @param itemSpacing 左右两个间距
/// @param previewWidth 预览宽度
- (instancetype)initWithFrame:(CGRect)frame itemSpacing:(CGFloat)itemSpacing previewWidth:(CGFloat)previewWidth;

@end

NS_ASSUME_NONNULL_END
