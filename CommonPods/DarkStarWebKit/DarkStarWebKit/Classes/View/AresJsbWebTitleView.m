//
//  AresJsbWebTitleView.m
//  Amen
//
//  Created by zhuyuhui on 2022/7/6.
//

#import "AresJsbWebTitleView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>

@interface AresJsbWebTitleView()

@property (nonatomic, strong, readwrite) UIImageView *iconImageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIView *leftSpaceView;
@property (nonatomic, strong) UIView *rightSpaceView;

@end


@implementation AresJsbWebTitleView


- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftSpaceView];
        [self addSubview:self.rightSpaceView];
    }
    return self;
}

- (void)configWithDict:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) return;
    NSString *typeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
    
    if ([typeStr isEqualToString:@"1"]) { // 只文字
        NSString *textStr = dict[@"title"];
        self.hidden = NO;
        self.titleLabel.text = textStr;
        [self configConstraintsWithType:1 withSuccess:NO];
    } else if ([typeStr isEqualToString:@"2"]) { // 只图片
        self.hidden = NO;
        NSString *imageUrlStr = dict[@"imgUrl"];
        kWeakSelf
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            kStrongSelf
            [strongSelf configConstraintsWithType:2 withSuccess:!error?YES:NO];
        }];
    } else if ([typeStr isEqualToString:@"3"]) { // 文字加图片
        self.hidden = NO;
        NSString *textStr = dict[@"title"];
        NSString *imageUrlStr = dict[@"imgUrl"];
        self.titleLabel.text = textStr;
        kWeakSelf
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            kStrongSelf
            [strongSelf configConstraintsWithType:3 withSuccess:!error?YES:NO];
        }];
    }
}

- (void)configConstraintsWithType:(NSInteger)type withSuccess:(BOOL)isSuccess {
    kWeakSelf
    [self.leftSpaceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.top.left.bottom.mas_offset(0);
        make.width.equalTo(strongSelf.rightSpaceView);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.top.bottom.mas_offset(0);
        if (type == 1) { // 只文字
            strongSelf.titleLabel.hidden = NO;
            make.width.mas_equalTo(0);
        } else if (type == 2) { // 只图片
            strongSelf.titleLabel.hidden = YES;
            make.left.equalTo(strongSelf.leftSpaceView.mas_right);
        } else {
            make.left.equalTo(strongSelf.leftSpaceView.mas_right);
            if (isSuccess) {
                make.width.and.height.mas_equalTo((24));
            } else {
                make.right.equalTo(strongSelf.titleLabel.mas_left).offset(0);
                make.width.mas_equalTo(0);
            }
        }
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.top.bottom.mas_offset(0);
        if (type == 1) { // 只文字
            strongSelf.titleLabel.hidden = NO;
            make.left.equalTo(strongSelf.leftSpaceView.mas_right);
            make.right.equalTo(strongSelf.rightSpaceView.mas_left);
        } else if (type == 2) { // 只图片
            strongSelf.titleLabel.hidden = YES;
            make.right.equalTo(strongSelf.rightSpaceView.mas_left);
            make.left.equalTo(strongSelf.iconImageView.mas_right);
            make.width.mas_equalTo(0);
        } else {
            strongSelf.titleLabel.hidden = NO;
            make.right.equalTo(strongSelf.rightSpaceView.mas_left);
            if (isSuccess) {
                make.left.equalTo(strongSelf.iconImageView.mas_right).offset(5);
            } else {
                make.left.equalTo(strongSelf.leftSpaceView.mas_right);
            }
        }
    }];
    [self.rightSpaceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_offset(0);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
- (UIView *)leftSpaceView {
    if (!_leftSpaceView) {
        _leftSpaceView = [[UIView alloc] init];
    }
    return _leftSpaceView;
}
- (UIView *)rightSpaceView {
    if (!_rightSpaceView) {
        _rightSpaceView = [[UIView alloc] init];
    }
    return _rightSpaceView;
}

@end
