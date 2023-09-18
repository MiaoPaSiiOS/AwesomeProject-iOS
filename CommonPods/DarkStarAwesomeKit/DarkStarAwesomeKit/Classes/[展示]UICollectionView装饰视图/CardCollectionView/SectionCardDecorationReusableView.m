
#import "SectionCardDecorationReusableView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
@implementation SectionCardDecorationCollectionViewLayoutAttributes

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

@end

@interface SectionCardDecorationReusableView()
@property(nonatomic, strong) UIImageView *background;
@end

@implementation SectionCardDecorationReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6.0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    self.background = [[UIImageView alloc] init];
    self.background.contentMode = UIViewContentModeScaleAspectFill;
    self.background.layer.cornerRadius = 12;
    self.background.layer.masksToBounds = YES;
    [self addSubview:self.background];
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

//通过apply方法让自定义属性生效
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:SectionCardDecorationCollectionViewLayoutAttributes.class]) {
        SectionCardDecorationCollectionViewLayoutAttributes *attributes = (SectionCardDecorationCollectionViewLayoutAttributes *)layoutAttributes;
//        self.backgroundColor = attributes.sectionCardModel.backgroundColor;
        [self.background sd_setImageWithURL:[NSURL URLWithString:attributes.sectionCardModel.backgroundUrl]];
//        [self.background sd_setImageWithURL:[NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_match%2F0%2F14243187226%2F0&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1647867172&t=fc061d3a9cc6639f9d2588a4836833de"]];

    }
}
@end
