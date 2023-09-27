//
//  ESTabBarView.m
//  TargetIOS
//
//  Created by zhuyuhui on 2022/8/23.
//

#import "ESTabBarView.h"
#import <Masonry/Masonry.h>
#import "DSAwesomeKitTool.h"

@interface ESTabBarView()

@property (nonatomic, strong) UIView * rootView;

@property (nonatomic, assign) CGFloat tabbarHeight;

@end

@implementation ESTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.clearColor;
    self.tabbarHeight = DSCommonMethods.tabBarContentHeight;
    [self initBgView];
    [self initBtn];
    return self;
}

- (void)initBgView{
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.image = [DSAwesomeKitTool imageNamed:@"tabbar_bg"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(self.tabbarHeight);
    }];
    if (DSCommonMethods.isIPHONEX) {
        CGFloat HOME_INDICATOR_HEIGHT = DSCommonMethods.tabBarHeight - DSCommonMethods.tabBarContentHeight;
        UIView * whiteView = [[UIView alloc] init];
        whiteView.translatesAutoresizingMaskIntoConstraints = NO;
        whiteView.backgroundColor = UIColor.whiteColor;
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_offset(0);
            make.height.mas_equalTo(HOME_INDICATOR_HEIGHT);
        }];
    }
}

- (void)initBtn{
    NSArray * titles = @[@"首页",
                         @"选股",
                         @"",
                         @"课程",
//                         @"自选",
//                         @"行情",
                         @"我的"];
    NSArray<NSString*> * itemImgNor = @[@"tabbar_home",
                                        @"tabbar_choose",
                                        @"",
                                        @"tabbar_course",
                                        @"tabbar_my",
                                        
//                                        @"tabbar_select",
//                                        @"tabbar_market",
                                        ];
    self.btnArray = [NSMutableArray new];
    CGFloat w = DSCommonMethods.screenWidth / 5;
    for (int i=0; i<titles.count; i++) {
        DSUIButton * btn = [[DSUIButton alloc] initWithFrame:CGRectMake(i * w, 0, w, self.tabbarHeight)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateSelected];
        [btn setTitleColor:[DSCommonMethods RGBA:51 green:51 blue:51] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setImage:[DSAwesomeKitTool imageNamed:itemImgNor[i]] forState:UIControlStateNormal];
        [btn setImage:[DSAwesomeKitTool imageNamed:[itemImgNor[i] stringByAppendingString:@"_sel"]]  forState:UIControlStateSelected];
        btn.imagePosition = DSUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        btn.tag = i;
        [self.btnArray addObject:btn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self selectIndex:0];
}

- (void)selectIndex:(NSInteger)index{
    for (DSUIButton * btn in self.btnArray) {
        btn.selected = NO;
    }
    self.btnArray[index].selected = YES;
}


- (void)btnClick:(DSUIButton*)btn{
    if (btn.tag == 2) {
        return;
    }
    
    [self selectIndex:btn.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTabBarViewClick:)]) {
        [self.delegate homeTabBarViewClick:btn.tag];
    }
}

@end

