//
//  REUITabBar.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/3.
//

#import "REUITabBar.h"

@interface REUITabBar()
//@property(nonatomic, strong) UIView *background;
@end

@implementation REUITabBar
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self addSubview:self.background];
//        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_offset(0);
//            make.left.mas_offset(32);
//            make.right.mas_offset(-32);
//            make.height.mas_equalTo(DSCommonMethods.tabBarContentHeight);
//        }];
//    }
//    return self;
//}
//
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    //重新排布tabBar的位置
//    int count = 4;
//    CGFloat width = (self.mj_w - 64) / count*1.0f;
//    CGFloat tabBarButtonIndex = 0;
//    for (UIView *subView in self.subviews) {
//        Class classStr = NSClassFromString(@"UITabBarButton");
//        if ([subView isKindOfClass:classStr]) {
////            subView.layer.borderColor = [UIColor redColor].CGColor;
////            subView.layer.borderWidth = 1;
//            subView.width = width;
//            subView.mj_x = width * tabBarButtonIndex + 32;
//            tabBarButtonIndex++;
//        }
//    }
//}
//
//#pragma mark - 懒加载
//- (UIView *)background {
//    if (!_background) {
//        _background = [[UIView alloc] init];
//        _background.backgroundColor = [UIColor whiteColor];
//        _background.layer.cornerRadius = DSCommonMethods.tabBarContentHeight/2;
////        _background.layer.masksToBounds = YES;
//        _background.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        _background.layer.shadowOffset = CGSizeMake(0,0.5);
//        _background.layer.shadowOpacity = 0.6;
//        _background.layer.shadowRadius = 1.0;
//    }
//    return _background;
//}
@end
