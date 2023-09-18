//
//  DSNavigationBar.m
//  DSViewController
//
//  Created by zhuyuhui on 2022/6/16.
//

#import "DSNavigationBar.h"
#import <Masonry/Masonry.h>

@interface DSNavigationBar ()
@property (nonatomic, strong) DSDataView *topView;
@property (nonatomic, strong) DSBarButton *rightBarButton;
@property (nonatomic, strong) UIImageView *topImageView;
@end

@implementation DSNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.background];
        [self addSubview:self.navigationBar];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.height.mas_equalTo(kNaviBarContentHeight);
        }];
        
        _leftBarButton = [[DSBarButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_leftBarButton];
        
        _rightBarButton = [[DSBarButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_rightBarButton];
        
        _topView = [[DSDataView alloc] initWithFrame:CGRectZero];
        [_topView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_topView];
        
        _topTitleView = [[UILabel alloc] initWithFrame:CGRectZero];
        [_topTitleView setBackgroundColor:[UIColor clearColor]];
        [_topTitleView setTextAlignment:NSTextAlignmentCenter];
        [_topView addSubview:_topTitleView];
        
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_topImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_topImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_topImageView];
    }
    return self;
}

- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc] init];
        [_background setBackgroundColor:[UIColor clearColor]];
        [_background setContentMode:UIViewContentModeScaleToFill];
        _background.tag = 10011;
    }
    return _background;
}

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] init];
        [_navigationBar setBackgroundColor:[UIColor clearColor]];
        _navigationBar.tag = 10012;
    }
    return _navigationBar;
}


- (void)addSubview:(UIView *)view {
    if (view.tag==10011||view.tag==10012||[view isKindOfClass:[UIProgressView class]]) {
        [super addSubview:view];
    } else{
        [self.navigationBar addSubview:view];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_background setImage:self.bgImg];
    if (self.leftBarButtonItem) {
        [_leftBarButton setHidden:NO];
        //  设置左按钮视图
        CGSize leftSize = [self barButtonSize:self.leftBarButtonItem];

        if (_leftBarButtonItem.style == DSBarButtonItemStyleBack) {
            leftSize = CGSizeMake(45,self.navigationBar.height);
            [_leftBarButton setImageInset:UIEdgeInsetsMake(12,20,12,5)];
        }
        
        /*设置位置和大小* 30*30*/
        _leftBarButton.size = leftSize;
        [_leftBarButton setTop:(self.navigationBar.height - leftSize.height)/2];
        
        [_leftBarButton setLeft:0];
        [_leftBarButton setItem:self.leftBarButtonItem];
    } else {
        [_leftBarButton setHidden:YES];
    }
    
    if (self.rightBarButtonItem) {
        [_rightBarButton setHidden:NO];
        //  设置右按钮视图
        CGSize rightSize = [self barButtonSize:self.rightBarButtonItem];
        /*设置位置和大小*/
        _rightBarButton.size = rightSize;
        [_rightBarButton setTop:(self.navigationBar.height - rightSize.height)/2];
        
        [_rightBarButton setRight:self.width - self.inset.right-10];
        [_rightBarButton setItem:self.rightBarButtonItem];
    } else {
        [_rightBarButton setHidden:YES];
    }

    CGFloat y = 0;
    CGFloat w = self.navigationBar.width/3+15;
    CGFloat h = self.navigationBar.height - y;
    [_topView setFrame:DSFrameAll(0,y,w,h)];
    [_topView setCenterX:self.navigationBar.centerX];
   
    [_topTitleView setFrame:DSFrameInset(_topView.frame,self.inset)];
    [_topImageView setFrame:DSFrameInset(_topView.frame,self.inset)];
    //  设置标题视图
    if (self.topItem) {
        [self setLogoImgView:y];
    }
}

#pragma mark - Private
-(void)setLogoImgView:(CGFloat)heithOffset {
    if (self.topItem.img && !self.topItem.title) {
        [_topImageView setFrame:CGRectMake(self.topItem.imgOffset, (self.height-self.topItem.img.size.height/2.f)/2,self.topItem.img.size.width/2.f, self.topItem.img.size.height/2.f)];
        [_topImageView setImage:self.topItem.img];
        [_topImageView setCenterY:self.centerY+heithOffset/2.0f];
        [_topImageView setCenterX:self.width/2];

    } else {
        [_topTitleView setFont:self.topItem.titleFont];
        [_topTitleView setText:self.topItem.title];
        [_topTitleView setTextColor:self.topItem.titleColor];
        [_topImageView removeFromSuperview];
    }
}

- (CGSize)barButtonSize:(DSBarButtonItem *)item {
    //宽度为视图的的1/3（因为可能会有左\右\标题 3个按钮）
    CGSize maxSize = CGSizeMake(self.width / 3, self.navigationBar.frame.size.height);
    if (item.style == DSBarButtonItemStyleBordered) {
        CGSize imgSize = CGSizeZero;
        if (item.img) {
            imgSize = item.img.size;
        }
        CGSize titleSize = CGSizeZero;
        if (item.title) {
            titleSize = [item.title boundingRectWithSize:maxSize options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes: @{ NSFontAttributeName : item.titleFont } context:nil].size;
        }
        CGFloat w = MAX(imgSize.width/2, titleSize.width);
        CGFloat h = MAX(imgSize.height/2, titleSize.height);
        return CGSizeMake(w, h);
    }
    else if (item.style == DSBarButtonItemStyleCustom) {
        CGSize viewSize = item.customView.size;
        CGFloat w = MIN(viewSize.width, maxSize.width);
        CGFloat h = MIN(viewSize.height, maxSize.height);
        return CGSizeMake(w, h);
    }
    else if (item.style == DSBarButtonItemStyleBack) {
        return CGSizeMake(item.img.size.width, item.img.size.height);
    }else{
        //其他按钮接着这里设置
        return CGSizeZero;
    }
}

- (void)setTopItem:(DSNavItem *)nTopItem {
    _topItem = nTopItem;
    [self setNeedsLayout];
}

- (void)setLeftBarButtonItem:(DSBarButtonItem *)leftBarButtonItem {
    _leftBarButtonItem = leftBarButtonItem;
    [self setNeedsLayout];
}

- (void)setRightBarButtonItem:(DSBarButtonItem *)rightBarButtonItem{
    _rightBarButtonItem = rightBarButtonItem;
    [self setNeedsLayout];
}
@end

