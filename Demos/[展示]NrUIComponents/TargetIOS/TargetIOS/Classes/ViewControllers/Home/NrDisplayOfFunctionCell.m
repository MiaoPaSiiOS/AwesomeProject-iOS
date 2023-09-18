//
//  NrDisplayOfFunctionCell.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/15.
//

#import "NrDisplayOfFunctionCell.h"
#import <NrBaseCoreKit/NrBaseCoreKit.h>
#import <Masonry/Masonry.h>
#import "NrDisplayOfFunction.h"

@interface NrDisplayOfFunctionCell()
@property(nonatomic, strong) UIImageView *gifView;
@property(nonatomic, strong) UILabel *titleLab;
@end

@implementation NrDisplayOfFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.gifView];
    [self.contentView addSubview:self.titleLab];
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.right.mas_offset(12);
        make.left.equalTo(self.gifView.mas_right).offset(5);
    }];
}


- (void)loadContent {
    self.titleLab.text = self.displayOf.title;
}





#pragma mark - 懒加载
- (UIImageView *)gifView {
    if (!_gifView) {
        _gifView = [[UIImageView alloc] init];
        _gifView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _gifView.layer.borderWidth = 0.5;
        _gifView.layer.borderColor = kRGBAColor(187, 198, 232, 0.81).CGColor;
        _gifView.layer.cornerRadius = 10;
    }
    return _gifView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}






+ (CGFloat)heightForRowAtIndexPath:(NrDisplayOfFunction *)displayOf {
    return 100;
}
@end
