
#import "SDMajletCellHead.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

static CGFloat margX = 15.0f;

@interface SDMajletCellHead (){
    UILabel *titleLab;
}

@end
@implementation SDMajletCellHead


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self buidUI];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [DSHelper addRectCorneToView:_bgView rect:_bgView.bounds corner:UIRectCornerTopLeft | UIRectCornerTopRight radius:8];
}

- (void)buidUI{
    
    CGFloat labWith = (self.bounds.size.width - 2*margX)/2;
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(margX, 0, labWith, self.bounds.size.height);
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = [DSHelper colorWithHexString:@"0x333333"];
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:titleLab];
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightBtn.backgroundColor = [DSHelper colorWithHexString:@"0xE00514"];
        _rightBtn.layer.cornerRadius = 2;
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn ds_setEnlargeEdge:15];
        _rightBtn.hidden = NO;
    }
    [self addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(16);
        make.width.mas_offset(32);
        make.centerY.equalTo(titleLab);
    }];
//    
//    _subTItleLab = [[UILabel alloc] init];
//    _subTItleLab.userInteractionEnabled = YES;
//    _subTItleLab.textAlignment = NSTextAlignmentRight;
//    _subTItleLab.textColor = Color1BB554;
//    _subTItleLab.font = [UIFont boldSystemFontOfSize:11];
//    _subTItleLab.hidden = YES;
//    [self addSubview:_subTItleLab];
//    [_subTItleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-12);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(50);
//        make.centerY.equalTo(titleLab);
//    }];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveAction)];
//    [_subTItleLab addGestureRecognizer:tap];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    titleLab.text = _title;
    
}
//
//- (void)setSubTitle:(NSString *)subTitle{
//
//    _subTitle = subTitle;
//    _subTItleLab.text = _subTitle;
//
//}

#pragma mark--action--
//-(void)saveAction{
//    _rightBtn.selected = NO;
//    _rightBtn.hidden = NO;
//    _subTItleLab.hidden = YES;
//    if (self.editBlock) {
//        self.editBlock(NO);
//    }
//}
-(void)rightAction:(UIButton *)btn{
    _rightBtn.selected = YES;
    if (btn.isSelected) {
//        _subTItleLab.hidden = NO;
//        _subTItleLab.text = @"保存";
        _rightBtn.hidden = YES;
        if (self.editBlock) {
            self.editBlock(YES);
        }
    }
}
#pragma mark---lazy---
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
