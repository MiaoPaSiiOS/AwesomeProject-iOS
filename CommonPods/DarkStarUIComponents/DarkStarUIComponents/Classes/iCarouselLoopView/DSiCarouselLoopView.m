
#import "DSiCarouselLoopView.h"

@interface DSiCarouselLoopView ()<iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) NSArray *modelGroup;

@property (nonatomic, strong) iCarousel *icarouselAdView;

//广告轮播定时
@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end
@implementation DSiCarouselLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _autoScrollTimeInterval = 3.0;
    _infiniteLoop = NO;
    _autoScroll = NO;
    _itemSpace = 30;
    _itemSize = CGSizeMake(self.frame.size.width - 50 * 2,self.frame.size.height);
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopAutoScrollTimer];
    } else {
        if (self.modelGroup.count > 1 && _autoScroll) {
            [self startAutoScrollTimer];
        }
    }
}

- (void)dealloc {
    [self stopAutoScrollTimer];
}

- (void)configureWithModel:(NSArray *)urls {
    [self initIcarouselAdViewMenuDo:urls];
    if (self.modelGroup.count > 1 && _autoScroll) {
        [self startAutoScrollTimer];
    }
}

#pragma mark - banner广告
- (void)initIcarouselAdViewMenuDo:(NSArray *)urls {
    self.modelGroup = urls;
    [self.icarouselAdView layoutIfNeeded];
    [self.icarouselAdView reloadData];
}

- (void)setCanScroll:(BOOL)canScroll{
    [self.icarouselAdView setScrollEnabled:canScroll];
}

#pragma mark - 广告轮播代理iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    NSInteger countOfAd = self.modelGroup.count;
    return countOfAd;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIImageView *imgView = nil;
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _itemSize.width, _itemSize.height)];
        view.backgroundColor = [UIColor clearColor];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _itemSize.width, _itemSize.height)];
        [view addSubview:imgView];
    } else {
        view.frame = self.bounds;
        imgView = [[view subviews] lastObject];
        imgView.frame = CGRectMake(0, 0, _itemSize.width, _itemSize.height);
    }
    [imgView setContentMode:UIViewContentModeScaleToFill];

    if ([self.modelGroup count] > 0) {
        NSString *urlString = [self.modelGroup objectAtIndex:index];
        [imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.defaultImage];
    } else {
        [imgView setImage:self.defaultImage];
    }

    if ([self.delegate respondsToSelector:@selector(customViewForItemAtIndex:reusingView:)]) {
        [self.delegate customViewForItemAtIndex:index reusingView:imgView];
        return view;
    }
    return view;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    CGFloat itemSpaceAspi = (_itemSpace / self.icarouselAdView.itemWidth);
    static CGFloat max_sacle = 1.0;
    CGFloat min_scale = 1 - itemSpaceAspi;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;

        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset * (self.icarouselAdView.itemWidth + _itemSpace), 0.0, 0.0);
//    static CGFloat max_sacle = 1.0f;
//    static CGFloat min_scale = 0.85f;
//    if (offset <= 1 && offset >= -1) {
//        float tempScale = offset < 0 ? 1+offset : 1-offset;
//        float slope = (max_sacle - min_scale) / 1;
//
//        CGFloat scale = min_scale + slope*tempScale;
//        transform = CATransform3DScale(transform, scale, scale, 1);
//    }else{
//        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
//    }
//
//    return CATransform3DTranslate(transform, offset * self.icarouselAdView.itemWidth * 1.13, 0.0, 0.0);

}


#pragma mark -广告轮播的点击事件
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:index];
    }
}

- (void)carouselDidScroll:(iCarousel *)carousel {
//    self.indicatePageControl.currentPage = (int)carousel.currentItemIndex;
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    //开始拖拽，定时器关闭
    [self stopAutoScrollTimer];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
//    [[SRSUIExposureManager sharedManager] startExposureCalculate];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    //停止拖拽，定时器开启
    [self startAutoScrollTimer];
}

#pragma mark - 开启计时器
- (void)startAutoScrollTimer {
    [self stopAutoScrollTimer];
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTimeInterval target:self selector:@selector(scrollAdPage) userInfo:nil repeats:_infiniteLoop];
}

#pragma mark - 停止计时器
- (void)stopAutoScrollTimer {
    if (self.autoScrollTimer != nil) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
}

#pragma mark - 广告自动循环
- (void)scrollAdPage {
    NSInteger nextIndex = self.icarouselAdView.currentItemIndex;
    nextIndex++;
    if (nextIndex >= self.modelGroup.count) {
        nextIndex = 0;
    }
    [self.icarouselAdView scrollToItemAtIndex:nextIndex animated:YES];
}

- (iCarousel *)icarouselAdView {
    if (!_icarouselAdView) {
        _icarouselAdView = [[iCarousel alloc] initWithFrame:self.bounds];
        _icarouselAdView.delegate = self;
        _icarouselAdView.dataSource = self;
        _icarouselAdView.pagingEnabled = YES;
        _icarouselAdView.type = iCarouselTypeCustom;
        [self addSubview:self.icarouselAdView];
        [_icarouselAdView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.leading.bottom.trailing.mas_equalTo(0);
        }];
    }
    return _icarouselAdView;
}

@end
