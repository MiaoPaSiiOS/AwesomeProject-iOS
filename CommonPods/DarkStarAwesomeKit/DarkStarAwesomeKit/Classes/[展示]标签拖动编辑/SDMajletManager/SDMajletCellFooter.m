
#import "SDMajletCellFooter.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@interface SDMajletCellFooter()
@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@end

@implementation SDMajletCellFooter

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.bgView1];
        [self addSubview:self.bgView2];
        [self.bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(0);
            make.bottom.equalTo(self.bgView2.mas_top).offset(0);
        }];
        [self.bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.bottom.mas_offset(0);
            make.height.mas_equalTo(12);
        }];
        
    }return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [DSHelper addRectCorneToView:_bgView1 rect:_bgView1.bounds corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8];
}

#pragma mark---lazy---
-(UIView *)bgView1 {
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]init];
        _bgView1.backgroundColor = [UIColor whiteColor];
    }
    return _bgView1;
}
-(UIView *)bgView2 {
    if (!_bgView2) {
        _bgView2 = [[UIView alloc]init];
    }
    return _bgView2;
}
@end
