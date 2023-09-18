
#import "CardCollectionView.h"
#import "SectionCardDecorationReusableView.h"
@implementation CardCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//手动调整装饰视图和cell的层级关系。
- (void)layoutSubviews {
    [super layoutSubviews];
    NSMutableArray *sectionCardViews = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:SectionCardDecorationReusableView.class]) {
            [sectionCardViews addObject:subview];
        }
    }
    
    for (UIView *decorationView in sectionCardViews) {
        [self sendSubviewToBack:decorationView];
    }
    
}
@end
