//
//  DisplayCustomCollectionTagScreen.m
//  AmenUIKit_Example
//
//  Created by zhuyuhui on 2022/6/16.
//  Copyright © 2022 zhuyuhui434@gmail.com. All rights reserved.
//

#import "DisplayCustomCollectionTagScreen.h"
#import <DarkStarUIComponents/DarkStarUIComponents.h>
#import "CustomCollectionTagCell.h"
#import "CustomCollectionTagSectionHeader.h"

@interface DisplayCustomCollectionTagScreen ()<NrCollectionCustomTagLayoutDelegate>
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) NrCollectionCustomTagLayout *tagLayout;
@end

@implementation DisplayCustomCollectionTagScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagLayout = [[NrCollectionCustomTagLayout alloc] init];
    self.tagLayout.delegate = self;
    self.tagLayout.itemHeight = 30;
    self.tagLayout.sectionInset = UIEdgeInsetsMake((10), (15), (10), (15));
    [self createTableViewWithFrame:self.dsView.bounds layout:self.tagLayout];
    [self.recylerView registerClass:[CustomCollectionTagCell class] forCellWithReuseIdentifier:@"BCMTrafficChargePreferenceCell"];
    [self.recylerView registerClass:[CustomCollectionTagSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BCMTrafficChargePreferenceHeaderView"];
    [self.recylerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"default-header"];
    [self.recylerView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"default-footer"];

    
    self.dataSource = @[
        @{
            @"title":@"发酵粉酒叟",
            @"modules":@[@"A",@"B",@"C",@"D"]
        },
        @{
            @"title":@"AB",
            @"modules":@[@"d发的发生的你好等级分地市hi返回的死哦",@"B",@"功夫格斗该公司归属感大范甘迪",@"D"]
        },
        @{
            @"title":@"CV",
            @"modules":@[@"A",@"佛挡杀佛到底是",@"C",@"天然天热帖热"]
        },
        @{
            @"title":@"VB",
            @"modules":@[@"别出心裁",@"B",@"让他特特特尔",@"D"]
        },
        @{
            @"title":@"BN",
            @"modules":@[@"惹我",@"453",@"干部不规范",@"D"]
        },
        @{
            @"title":@"BN威锋网",
            @"modules":@[@"惹我",@"453放大法第四十JFJF经济纠纷松弟",@"干部不规范发生的房间所涉及的就女女苍南县",@"D"]
        },
        @{
            @"title":@"BN樊登读书仿电商",
            @"modules":@[@"惹我",@"44））53",@"干部不发的发生的",@"发发发建瓯盘附加费评审等D"]
        },
        @{
            @"title":@"BN发的发的发的是",
            @"modules":@[@"惹我",@"453",@"干部不规范",@"D"]
        }
    ].mutableCopy;
    
    // Do any additional setup after loading the view.
}

#pragma mark - NrCollectionCustomTagLayoutDelegate
- (CGFloat)NrCollectionCustomTagLayout:(NrCollectionCustomTagLayout *)layout tagWidthForItemAt:(NSIndexPath *)indexPath {
    CGFloat maxTagWidth = layout.collectionView.width - self.tagLayout.sectionInset.left - self.tagLayout.sectionInset.right;
    CGFloat minTagWidth = (maxTagWidth - self.tagLayout.minimumInteritemSpacing * 2) / 3;
    NSString *text = [self rowTextViewAtIndexPath:indexPath];
    CGFloat textW = [self textWidth:text font:[UIFont systemFontOfSize:13]];

    textW += (30);//加上左右间距
    textW = MAX(minTagWidth, textW);
    textW = MIN(maxTagWidth, textW);
    return textW;
}

- (CGSize)NrCollectionCustomTagLayout:(NrCollectionCustomTagLayout *)layout sizeForSupplementaryElementOfKind:(nonnull NSString *)kind section:(NSInteger)section {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.dataSource.count <= 0) {
            return CGSizeZero;
        }
        return CGSizeMake(layout.collectionView.width, 30);
    } else {
        return CGSizeZero;
    }
}

// 根据文字 确定label的宽度
- (CGFloat)textWidth:(NSString *)text font:(UIFont *)font{
    CGRect rect = [text boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

#pragma mark - 数据处理
/// 获取组头
/// @param indexPath <#indexPath description#>
- (NSString *)sectionTitleViewAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *state = [self.dataSource objectAtIndex:indexPath.section];
    return state[@"title"];
}

/// cell中的文字
/// @param indexPath <#indexPath description#>
- (NSString *)rowTextViewAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *state = [self.dataSource objectAtIndex:indexPath.section];
    NSArray *modules = state[@"modules"];
    return modules[indexPath.row];
}



#pragma mark - delegate/dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *state = [self.dataSource objectAtIndex:section];
    NSArray *modules = state[@"modules"];
    return modules.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"default-header" forIndexPath:indexPath];
        if (self.dataSource.count > 0) {
            CustomCollectionTagSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BCMTrafficChargePreferenceHeaderView" forIndexPath:indexPath];
            headerView.botlabel.text = [self sectionTitleViewAtIndexPath:indexPath];
            return headerView;
        }
        return cell;
    } else {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"default-footer" forIndexPath:indexPath];
        return cell;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BCMTrafficChargePreferenceCell" forIndexPath:indexPath];
    [cell configDotText:[self rowTextViewAtIndexPath:indexPath]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}



@end
