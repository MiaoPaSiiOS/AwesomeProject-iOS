
#import "SRSAutoLayoutScrollView.h"

@interface SRSAutoLayoutScrollView ()

@property (nonatomic, readwrite) UIView *contentView;
@end

@implementation SRSAutoLayoutScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
}

- (void)dealloc {
    _contentView = nil;
}

- (void)didMoveToSuperview {
    if (self.isHorizontal) { // 水平自动布局
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            // 设置contentView的高度
            make.height.equalTo(self);
        }];
    } else { // 垂直自动布局
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            // 设置contentView的宽度
            make.width.equalTo(self);
        }];
    }
}
@end
