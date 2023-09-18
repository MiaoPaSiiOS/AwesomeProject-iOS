//
//  CustomCollectionTagCell.m
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/6/16.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import "CustomCollectionTagCell.h"
#import "CustomCollectionTagShapeView.h"
#import <Masonry/Masonry.h>

/// 十六进制颜色, rgbValue为16进制数字
#ifndef kHexAColor
#define kHexAColor(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#endif
@interface CustomCollectionTagCell()
@property(nonatomic, strong) CustomCollectionTagShapeView *background;
/** 描述 */
@property(nonatomic, strong) UILabel *botlabel;
@end

@implementation CustomCollectionTagCell

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.alpha = highlighted ? .5f:1.f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupStyleWithTitle];
    }
    return self;
}

- (void)configDotText:(NSString *)text {
    self.botlabel.text = text;
    [self setUpShadowBorder];
}

- (void)setupStyleWithTitle {
    [self.contentView addSubview:self.background];
    [self.background addSubview:self.botlabel];
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
    [self.botlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.background).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - Shadow & Border
- (void)setUpShadowBorder {
    //布局：为了获取子控件frame
//    [self layoutIfNeeded];
    
    ///1、设置阴影
    CGSize cornerRadii = CGSizeMake(10,10);
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomRight;;
    _background.backgroundColor = kHexAColor(0xf4f5f7, 1);
    _background.corners = corners;
    _background.cornerRadii = cornerRadii;
    _background.borderLayer.fillColor = [UIColor clearColor].CGColor;
    _background.borderLayer.strokeColor = [UIColor redColor].CGColor;

    [_background layoutIfNeeded];
}





#pragma mark - 懒加载
- (UILabel *)botlabel {
    if (_botlabel == nil) {
        _botlabel = [[UILabel alloc] init];
        _botlabel.textColor = [UIColor blackColor];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.font =  [UIFont systemFontOfSize:13];
    }
    return _botlabel;
}

- (CustomCollectionTagShapeView *)background {
    if (!_background) {
        _background = [[CustomCollectionTagShapeView alloc] init];
        _background.layer.shadowColor = kHexAColor(0x000000, 1).CGColor;
        _background.layer.shadowRadius = 5.f;
        _background.layer.shadowOffset = CGSizeMake(2, 2.5);//x向右为正，y向下为正; 默认(0, -3)
        _background.layer.shadowOpacity = 1.f;
    }
    return _background;
}


#pragma mark - 工具
+ (NSAttributedString *)attrText:(NSString *)text color:(UIColor *)color font:(UIFont *)font {
    return [[NSAttributedString alloc] initWithString:(text ? text:@"") attributes:@{
        NSForegroundColorAttributeName:color,
        NSFontAttributeName:font
    }];
}

+ (CGFloat)calculateWidthByH:(CGFloat)h attributedText:(NSAttributedString *)attributedText {
    UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, h)];
    tl.attributedText = attributedText;
    [tl sizeToFit];
    return tl.frame.size.width;
}

+ (CGFloat)calculateheightByW:(CGFloat)w attributedText:(NSAttributedString *)attributedText {
    UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 0)];
    tl.numberOfLines = 0;
    tl.attributedText = attributedText;
    [tl sizeToFit];
    return tl.frame.size.height;
}


@end
