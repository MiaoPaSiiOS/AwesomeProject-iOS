//
//  SDMajletCollectionView.m
//  REWLY
//
//  Created by zhuyuhui on 2023/4/11.
//

#import "SDMajletCollectionView.h"
#import "SDMajletViewSectionDecorationReusableView.h"
@implementation SDMajletCollectionView

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
        if ([subview isKindOfClass:SDMajletViewSectionDecorationReusableView.class]) {
            [sectionCardViews addObject:subview];
        }
    }
    
    for (UIView *decorationView in sectionCardViews) {
        [self sendSubviewToBack:decorationView];
    }
}

@end
