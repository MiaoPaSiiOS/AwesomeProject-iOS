//
//  ESTabBarView.h
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import <UIKit/UIKit.h>
#import <DarkStarUIComponents/DarkStarUIComponents.h>
NS_ASSUME_NONNULL_BEGIN

@protocol HomeTabBarViewDelegate <NSObject>

@required

- (void)homeTabBarViewClick:(NSInteger)index;

@end


@interface ESTabBarView : UIView

@property (nonatomic, strong) NSMutableArray<NrUIButton*> * btnArray;

@property (nonatomic, weak) id<HomeTabBarViewDelegate>  delegate;

- (void)selectIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END
