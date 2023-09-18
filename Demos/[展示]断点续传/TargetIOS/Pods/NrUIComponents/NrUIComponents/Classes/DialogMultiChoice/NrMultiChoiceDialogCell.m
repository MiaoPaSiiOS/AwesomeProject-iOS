
#import "NrMultiChoiceDialogCell.h"
#import "NrMultiChoiceDialog.h"
@implementation NrMultiChoiceDialogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCell];
    
    [self buildSubview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupCell];
        
        [self buildSubview];
    }
    
    return self;
}

- (void)setupCell {
    
}


- (void)buildSubview {
    [self.contentView addSubview:self.selectImgView];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectImgView.superview);
        make.right.equalTo(self.selectImgView.superview).offset(-12);
    }];

    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.superview);
        make.left.equalTo(self.titleLabel.superview).offset(12);
        make.right.equalTo(self.titleLabel.superview).offset(-12);
    }];

    [self.contentView addSubview:self.bLine];
    [self.bLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.bLine.superview);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)loadContent {
    if ([self.data isKindOfClass:NSString.class]) {
        self.titleLabel.text = self.data;
    }
    
    if ([self.dialog.disableItems containsObject:self.data]) {
        self.selectImgView.image = [self imageName:@"checkbox_disable"];
        self.contentView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.15];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        if ([self.dialog.checkedItems containsObject:self.data]) {
            self.selectImgView.image = [self imageName:@"checkbox_checked"];
        } else {
            self.selectImgView.image = [self imageName:@"checkbox_uncheck"];
        }
    }
}

- (UIImage *)imageName:(NSString *)name {
    return NrPOD_IMAGE(name, Nr_BUNDLE(@"NrDialogMultiChoiceAssets", @"NrUIComponents"));
}

#pragma mark - 懒加载
- (UIView *)bLine {
    if (!_bLine) {
        _bLine = [[UIView alloc] init];
        _bLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _bLine;
}

- (UIImageView *)selectImgView {
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
    }
    return _selectImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
@end
