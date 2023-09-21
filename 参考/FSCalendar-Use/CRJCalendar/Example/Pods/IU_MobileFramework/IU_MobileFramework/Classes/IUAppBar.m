//
//  IUAppBar.m
//  CRJKit
//
//  Created by zhuyuhui on 2020/9/14.
//

#import "IUAppBar.h"

@implementation IUAppBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView = [[UIImageView alloc] init];
        self.bgView.userInteractionEnabled = YES;;
        
        self.navigationBar = [[UIView alloc] init];
        self.navigationBar.backgroundColor = [UIColor clearColor];
        
        self.leftBarContainers = [[UIView alloc] init];
        self.leftBarContainers.backgroundColor = [UIColor clearColor];

        self.rightBarContainers = [[UIView alloc] init];
        self.rightBarContainers.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.divideLine = [[UIView alloc] init];

        [self addSubview:self.bgView];
        [self addSubview:self.navigationBar];
        [self addSubview:self.divideLine];
        
        [self.navigationBar addSubview:self.leftBarContainers];
        [self.navigationBar addSubview:self.rightBarContainers];
        [self.navigationBar addSubview:self.titleLabel];
    
        [self layout];
    }
    return self;
}


- (void)layout{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.divideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [self.leftBarContainers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.leftBarContainers.superview);
    }];
    [self.rightBarContainers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.rightBarContainers.superview);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.titleLabel.superview);
        make.left.equalTo(self.leftBarContainers.mas_right).offset(10);
        make.right.equalTo(self.rightBarContainers.mas_left).offset(-10);
    }];
}

-(void)setLeftBarButtonItems:(NSArray<UIView *> *)leftBarButtonItems{
    _leftBarButtonItems = leftBarButtonItems;
    [self.leftBarContainers.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastItem;
    for (UIView *item in leftBarButtonItems) {
        [self.leftBarContainers addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(item.superview);
            make.width.mas_equalTo(item.frame.size.width);
            if (lastItem) {
                make.left.equalTo(lastItem.mas_right).offset(5);
            } else {
                make.left.equalTo(item.superview).offset(5);
            }
        }];
        lastItem = item;
    }
    //撑起父视图
    [lastItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastItem.superview).offset(-5);
    }];
}

- (void)setRightBarButtonItems:(NSArray<UIView *> *)rightBarButtonItems{
    _rightBarButtonItems = rightBarButtonItems;
    [self.rightBarContainers.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastItem;
    for (UIView *item in rightBarButtonItems) {
        [self.rightBarContainers addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(item.superview);
            make.width.mas_equalTo(item.frame.size.width);
            if (lastItem) {
                make.left.equalTo(lastItem.mas_right).offset(5);
            } else {
                make.left.equalTo(item.superview).offset(5);
            }
        }];
        lastItem = item;
    }
    //撑起父视图
    [lastItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastItem.superview).offset(-5);
    }];
}
@end
