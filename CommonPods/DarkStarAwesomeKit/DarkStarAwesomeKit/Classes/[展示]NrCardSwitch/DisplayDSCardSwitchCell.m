//
//  DisplayDSCardSwitchCell.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/15.
//

#import "DisplayDSCardSwitchCell.h"
#import <Masonry/Masonry.h>
@implementation DisplayDSCardSwitchCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.container = [[UIView alloc] init];
        self.container.backgroundColor = [UIColor whiteColor];
        self.container.layer.cornerRadius = 10;
        self.container.layer.masksToBounds = YES;
        [self.contentView addSubview:self.container];
        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        self.icon = [[UIImageView alloc] init];
        [self.container addSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.container).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        
        self.textLab = [[UILabel alloc] init];
        self.textLab.textColor = [UIColor blueColor];
        self.textLab.textAlignment = NSTextAlignmentCenter;
        [self.container addSubview:self.textLab];
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.container).insets(UIEdgeInsetsMake(12, 12, 12, 12));
        }];
    }
    return self;
}

@end
