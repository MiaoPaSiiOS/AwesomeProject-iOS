
#import "SectionCardArmbandDecorationReusableView.h"

#import "DSAwesomeKitTool.h"

@implementation SectionCardArmbandDecorationCollectionViewLayoutAttributes


@end


@interface SectionCardArmbandDecorationReusableView()
/// 袖标icon视图
@property(nonatomic, strong) UIImageView *armbandImageView;
@end

@implementation SectionCardArmbandDecorationReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 80, 53);
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.backgroundColor = [UIColor clearColor];
    self.armbandImageView = [[UIImageView alloc] init];
    self.armbandImageView.frame = CGRectMake(0, 0, 80, 53);
    self.armbandImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.armbandImageView];
}

//通过apply方法让自定义属性生效
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:SectionCardArmbandDecorationCollectionViewLayoutAttributes.class]) {
        SectionCardArmbandDecorationCollectionViewLayoutAttributes *attributes = (SectionCardArmbandDecorationCollectionViewLayoutAttributes *)layoutAttributes;
        if (attributes.imageName) {
            UIImage *image = [DSAwesomeKitTool imageNamed:attributes.imageName];
            self.armbandImageView.image = image;
            
        } else {
            self.armbandImageView.image = nil;
        }

    }
}
@end
