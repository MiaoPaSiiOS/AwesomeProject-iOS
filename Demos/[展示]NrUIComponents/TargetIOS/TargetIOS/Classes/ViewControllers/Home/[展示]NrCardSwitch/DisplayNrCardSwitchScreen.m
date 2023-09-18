//
//  DisplayNrCardSwitchScreen.m
//  NrDisplayOfCommonFunctions
//
//  Created by zhuyuhui on 2022/8/15.
//

#import "DisplayNrCardSwitchScreen.h"
#import <NrUIComponents/NrCardSwitch.h>
#import "DisplayNrCardSwitchCell.h"

@interface DisplayNrCardSwitchScreen () <NrCardSwitchDelegate,NrCardSwitchDataSource>
@property(nonatomic, strong) NrCardSwitch *cardSwitch;
@property(nonatomic, strong) UIPageControl *pageControl;
@end

@implementation DisplayNrCardSwitchScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nrView addSubview:self.cardSwitch];
    [self.cardSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.nrView).insets(UIEdgeInsetsMake(0, 0, kTabBarHeight, 0));
    }];
    
    [self.cardSwitch addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(20);
    }];
    
    
    self.cardSwitch.models = @[@"item-1",@"item-2",@"item-3",@"item-4",@"item-5"];
    self.pageControl.numberOfPages = self.cardSwitch.models.count;
}


#pragma mark - NrCardSwitchDataSource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DisplayNrCardSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DisplayNrCardSwitchCell" forIndexPath:indexPath];
    cell.textLab.text = [NSString stringWithFormat:@"%ld : %@",(long)indexPath.row, self.cardSwitch.models[indexPath.row]];
    return cell;
}

#pragma mark - NrCardSwitchDelegate
- (void)cardSwitchDidScrollToIndex:(NSInteger)index {
    self.pageControl.currentPage = index;
}

- (void)cardSwitchDidClickAtIndex:(NSInteger)index {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NrCardSwitch *)cardSwitch {
    if (!_cardSwitch) {
        _cardSwitch = [[NrCardSwitch alloc] init];
        [_cardSwitch.collectionView registerClass:DisplayNrCardSwitchCell.class forCellWithReuseIdentifier:@"DisplayNrCardSwitchCell"];
        _cardSwitch.delegate = self;
        _cardSwitch.dataSource = self;
        _cardSwitch.layer.borderColor = [UIColor redColor].CGColor;
        _cardSwitch.layer.borderWidth = 2;
    }
    return _cardSwitch;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.pageIndicatorTintColor = kHexAColor(0x000000, 0.4);
        _pageControl.currentPageIndicatorTintColor = kHexColor(0x000000);
    }
    return _pageControl;
}




@end
