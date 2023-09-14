
#import "DSBarButton.h"
#import "DSBarButtonItem.h"

@implementation DSBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _barButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_barButton setFrame:DSFrameAllInset(frame)];
        [_barButton setBackgroundColor:[UIColor clearColor]];
        [_barButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_barButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_barButton addTarget:self action:@selector(barClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_barButton];
    }
    return self;
}

- (id)initWithItem:(DSBarButtonItem *)nItem{
    if (self = [self initWithFrame:CGRectZero]) {
        _item = nItem;
    }
    return self;
}

-(void)setItem:(DSBarButtonItem *)item{
    _item = item;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.frame;
    if (self.item) {
        /*
         *使用边框填充视图
         */
        [_barButton setFrame:DSFrameInset(frame, self.inset)];
        //自定视图按钮
        if (self.item.style == DSBarButtonItemStyleCustom) {
            if (self.item.customView) {
                /*视图依赖判断,是否在当前视图上*/
                if (![self.item.customView isDescendantOfView:self]) {
                    [self addSubview:self.item.customView];
                }
                /*填充矩形框*/
                [self.item.customView setFrame:DSFrameInset(frame, self.inset)];
            }
        }
        //普通按钮
        else if (self.item.style == DSBarButtonItemStyleBordered) {
            if (self.item.customView) {
                if ([self.item.customView isDescendantOfView:self]) {
                    [self.item.customView removeFromSuperview];
                }
            }
            /*设置按钮填充参数*/
            [_barButton setContentEdgeInsets:self.inset];
            
            [_barButton setImage:self.item.img forState:UIControlStateNormal];
            [_barButton setImage:self.item.imgH forState:UIControlStateHighlighted];
            //40  视实际情况而定
            [_barButton setImageEdgeInsets:self.imageInset];
            
            /*设置两种状态的标题，防止某种状态下，标题遗失*/
            [_barButton setTitle:self.item.title forState:UIControlStateNormal];
            [_barButton setTitle:self.item.title forState:UIControlStateHighlighted];
            /*设置两种状态下标题颜色*/
            [_barButton setTitleColor:self.item.titleColor forState:UIControlStateNormal];
            [_barButton setTitleColor:self.item.titleColorH forState:UIControlStateHighlighted];
            /*设置标题字体，可在item初始化时给出*/
            [_barButton.titleLabel setFont:self.item.titleFont];
        }
        //返回按钮
        else if (self.item.style == DSBarButtonItemStyleBack) {
            if (self.item.customView) {
                if ([self.item.customView isDescendantOfView:self]) {
                    [self.item.customView removeFromSuperview];
                }
            }
           
            /*设置按钮填充参数*/
            [_barButton setContentEdgeInsets:self.inset];
            [_barButton setImageEdgeInsets:self.imageInset];
            //使用定制图片，和订制是"文字按钮"
//            [_barButton setTitle:@"返回" forState:UIControlStateNormal];
//            [_barButton setTitleEdgeInsets:UIEdgeInsetsMake(12,-50,10,0)];
            
            [_barButton setImage:self.item.img forState:UIControlStateNormal];
            [_barButton setImage:self.item.img forState:UIControlStateHighlighted];
          
            /*设置两种状态下标题颜色*/
            [_barButton setTitleColor:self.item.titleColor forState:UIControlStateNormal];
            [_barButton setTitleColor:self.item.titleColor forState:UIControlStateHighlighted];//self.item.titleColorH
           
            /*设置标题字体，可在item初始化时给出*/
            [_barButton.titleLabel setFont:self.item.titleFont];
        }
    }
}

#pragma mark - Selector
- (void)barClick:(id)sender{
    if (self.item.target) {
        if ([self.item.target respondsToSelector:self.item.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            // 父类实现了此方法
            [self.item.target performSelector:self.item.action withObject:self];
#pragma clang diagnostic pop
        }
    }
}



@end
