
#import "SDMajletCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "DSAwesomeKitTool.h"
@interface SDMajletCell()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) CAShapeLayer *borderLayer;
@end

@implementation SDMajletCell


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self buidUI];
    }
    return self;
}



-(void)buidUI{
    
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.editImgView];
    [self addSubview:self.titleLab];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.centerX.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.editImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.equalTo(self.iconImageView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(8);
    }];
    
    
    [self addBorderLayer];
    
    
}

-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1.5f;
    _borderLayer.lineDashPattern = @[@5, @3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = true;
}




-(void)setFont:(CGFloat)font{
    _font = font;
    self.titleLab.font = [UIFont systemFontOfSize:_font];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}
-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    [self refreshIconView];
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

-(void)setIsMoving:(BOOL)isMoving{
    _isMoving = isMoving;
    if (_isMoving) {
        self.titleLab.textColor = [UIColor lightGrayColor];
        self.iconImageView.image = [DSAwesomeKitTool imageNamed:[NSString stringWithFormat:@"%@Gray",_iconName]];
        self.borderLayer.hidden = false;
    }else{
        ;
        self.titleLab.textColor = [DSHelper colorWithHexString:@"0x666666"];
        [self refreshIconView];
        self.borderLayer.hidden = true;
    }
}

- (void)refreshIconView {
    if ([DSHelper isStringEmptyOrNil:(self.iconName)]) {
        self.iconImageView.image = [DSHelper imageWithColor:[DSHelper colorWithHexString:@"0xD8D8D8"]];
    } else if ([self.iconName containsString:@"http"]){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.iconName] placeholderImage:[DSHelper imageWithColor:[DSHelper colorWithHexString:@"0xD8D8D8"]] options:SDWebImageAllowInvalidSSLCertificates];

    } else if ([DSAwesomeKitTool imageNamed:self.iconName]){
        self.iconImageView.image = [DSAwesomeKitTool imageNamed:self.iconName];
    } else {
        self.iconImageView.image = [DSHelper imageWithColor:[DSHelper colorWithHexString:@"0xD8D8D8"]];
    }
}


#pragma mark---lazy---
-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(UIImageView *)editImgView{
    if (!_editImgView) {
        _editImgView = [[UIImageView alloc]init];
    }
    return _editImgView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [DSHelper colorWithHexString:@"0x666666"];
        _titleLab.font = [UIFont systemFontOfSize:12];
    }
    return _titleLab;
}
@end
