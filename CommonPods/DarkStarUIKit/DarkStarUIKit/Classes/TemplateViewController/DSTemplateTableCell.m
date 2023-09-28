//
//  DSTemplateTableCell.m
//  DarkStarUIKit
//
//  Created by zhuyuhui on 2023/9/17.
//

#import "DSTemplateTableCell.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <DarkStarResourceKit/DarkStarResourceKit.h>
@interface DSTemplateTableCell()
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIImageView *arrowImgV;
@property(nonatomic, strong) UIView *bottomLine;
@end

@implementation DSTemplateTableCell

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
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.numberOfLines = 0;
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 10, 12));
        }];
        
        self.arrowImgV = [[UIImageView alloc] init];
        self.arrowImgV.image = [DSResourceTool imageNamed:@"nr_nav_goBack_black"];
        [self.contentView addSubview:self.arrowImgV];
        [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        self.arrowImgV.angle = M_PI;
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [DSHelper colorWithHexString:@"0xEEEEEE"];
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(DSDeviceInfo.LINE_HEIGHT);
        }];

    }
    return self;
}

- (void)setModel:(DSTemplate *)model {
    _model = model;
    self.titleLab.text = model.title;
}
@end
