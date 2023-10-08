
#import "SDMajletView.h"
#import <Masonry/Masonry.h>
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import "SDMajletCell.h"
#import "SDMajletCellHead.h"
#import "SDMajletCellFooter.h"
#import "SDMajletModel.h"
#import "DSAwesomeKitTool.h"
static CGFloat const kHeaderHeight = 44;
static CGFloat const kFooterHeight = 24;

static CGFloat const kMargSpaceX = 0.0f;  //cell间距x
static CGFloat const kMargSpaceY = 0.0f;  //cell间距y
static CGFloat const kColumnNumber = 5.0f;// cell 列数

@interface SDMajletView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
SDMajletViewCollectionViewFlowLayoutDelegate
>
@property (nonatomic, strong) SDMajletCell *dragingCell;  //被拖动的(瓷砖)cell(item)
@property (nonatomic, strong) NSIndexPath *dragingFromindexPath; //被拖动的cell的indexPaht
@property (nonatomic, strong) NSIndexPath *dragingToindexPaht;   //目标cell的indexPaht
@property (nonatomic,assign) BOOL hasSelect;

@end

@implementation SDMajletView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray array];
        _hasSelect = NO;
        [self createUI];
    }
    return self;
}

- (void)createUI{
#pragma mark - 创建collectionView
    UIEdgeInsets contentInset = UIEdgeInsetsMake(8, 12, DSDeviceInfo.tabBarHeight, 12);
    //flowLayout布局
    SDMajletViewCollectionViewFlowLayout *flowLayout = [[SDMajletViewCollectionViewFlowLayout alloc] init];
    flowLayout.decorationDelegate = self;
    CGFloat spaceCount = kColumnNumber - 1 ; //(间隙count永远比列数多1)
    CGFloat cellWith = (self.bounds.size.width - contentInset.left - contentInset.right - spaceCount*kMargSpaceX)/kColumnNumber;
    //布局item大小
    flowLayout.itemSize = CGSizeMake(cellWith, 63);
//    //布局边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //布局最小行间距
    flowLayout.minimumLineSpacing = kMargSpaceY;
    //布局最小列间距
    flowLayout.minimumInteritemSpacing = kMargSpaceX;
    //布局头部viewSize
    flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, kHeaderHeight);
    flowLayout.footerReferenceSize = CGSizeMake(self.frame.size.width, kFooterHeight);
    
    _collectionView = [[SDMajletCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [DSHelper colorWithHexString:@"0xF4F4F4"];
    _collectionView.contentInset = contentInset;
    //复用ID必须和代理中的ID一致
    [_collectionView registerClass:[SDMajletCell class] forCellWithReuseIdentifier:@"SDMajletCell"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"default-cell"];
    
    //注册头部视图
    [_collectionView registerClass:[SDMajletCellHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SDMajletCellHead"];
    [_collectionView registerClass:[SDMajletCellFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SDMajletCellFooter"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
#pragma mark - 创建一个单独的(瓷砖)cell用于跟随手势拖动
    _dragingCell = [[SDMajletCell alloc] initWithFrame:CGRectMake(0, 0, flowLayout.itemSize.width, flowLayout.itemSize.height)];
    _dragingCell.hidden = YES;
    [self addSubview:_dragingCell];
    
    
#pragma mark - 创建长按拖动手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPressGesture.minimumPressDuration = 0.3f;
    [_collectionView addGestureRecognizer:longPressGesture];
    
    
    
}
#pragma mark - 长按手势方法
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    
    //1 获取手势触发点Point
    CGPoint point = [gesture locationInView:_collectionView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self dragBegin:point];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            [self dragChange:point];
        }
            break;
          
        case UIGestureRecognizerStateEnded:
        {
            [self dragEnd:point];
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - 开始拖动
-(void)dragBegin:(CGPoint)point{
    //获取拖动的cell的indexPaht
    _dragingFromindexPath = [self getDragingFromIndexPathWithPoint:point];
    
    if (!_dragingFromindexPath) {
        return;
    }
    //把被拖动cell拿到最上层
    [_collectionView bringSubviewToFront:_dragingCell];
    
    //拿到被拖动的真正cell 更新样式
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_dragingFromindexPath];
    if ([cell isKindOfClass:SDMajletCell.class]) {
        SDMajletCell *cell = (SDMajletCell*)[_collectionView cellForItemAtIndexPath:_dragingFromindexPath];
        cell.isMoving = YES;
        //更新拖动(瓷砖)的cell样式
        _dragingCell.frame = cell.frame;
        _dragingCell.title = cell.title;
        _dragingCell.iconName = cell.iconName;
        _dragingCell.hidden = NO;
        _dragingCell.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }    
}

#pragma mark - 拖动中...
-(void)dragChange:(CGPoint)point{
    if (!_dragingFromindexPath) {
        return;
    }
    //让被拖动的cell 更随手势移动
    _dragingCell.center = point;
    
    //获取目标cell的indexPaht
    _dragingToindexPaht = [self getDragingToIndexPathWithPoint:point];
    
    //交换位置,如果目标indexPath找不到则不交换
    if (_dragingFromindexPath && _dragingToindexPaht) {
        //先更新数据源
        [self uplogadInusesTitles];
        //在交换位置(UI层面)
        [_collectionView moveItemAtIndexPath:_dragingFromindexPath toIndexPath:_dragingToindexPaht];
        _dragingFromindexPath = _dragingToindexPaht;
       
    }
}

#pragma mark - 结束拖动
-(void)dragEnd:(CGPoint)point{
    if (!_dragingFromindexPath) {
        return;
    }
    CGRect newFrame = [_collectionView cellForItemAtIndexPath:_dragingFromindexPath].frame;
    _dragingCell.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.3f animations:^{
        //跟新拖动cell的样式
        self->_dragingCell.frame = newFrame;
    } completion:^(BOOL finished) {
        self->_dragingCell.hidden = YES;
        
        //拿到被拖动的真正cell 更新样式
        UICollectionViewCell *cell = [self->_collectionView cellForItemAtIndexPath:self->_dragingFromindexPath];
        if ([cell isKindOfClass:SDMajletCell.class]) {
            SDMajletCell *cell = (SDMajletCell*)[self->_collectionView cellForItemAtIndexPath:self->_dragingFromindexPath];
            cell.isMoving = NO;
        }
    }];
}

//找出被拖动的cell的indexPath
- (NSIndexPath*)getDragingFromIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *indexPahtTemp = nil;
    
    //获取当前可见cell的indexPaht组
    NSArray *indexPahtArr = [_collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in indexPahtArr) {
        //下半部分不用排序
        if (indexPath.section >0) {
            continue;
        }
        //上半部分中 找出点所在的indexPath
        BOOL isContains = CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point);
        if (isContains == YES) {
            indexPahtTemp = indexPath;
            break;
        }
    }
    return indexPahtTemp;
}


//找出目标cell的indexPath
-(NSIndexPath*)getDragingToIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *indexPahtTemp = nil;
    //获取当前可见cell的indexPaht组
    NSArray *indexPahtArr = [_collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in indexPahtArr) {
        //如果是自己,则不需要排序
        if (indexPath == _dragingFromindexPath) {
            continue;
        }
        //下半部分不用排序
        if (indexPath.section >0) {
            continue;
        }
        //上半部分中 找出点所在的indexPath
        BOOL isContains = CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point);
        if (isContains == YES) {
            indexPahtTemp = indexPath;
            break;
        }
    }
    return indexPahtTemp;
}


#pragma mark - SDMajletViewCollectionViewFlowLayoutDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SDMajletViewCollectionViewFlowLayout *)collectionViewLayout decorationInsetForSectionAt:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(SDMajletViewCollectionViewFlowLayout *)collectionViewLayout decorationColorForSectionAt:(NSInteger)section {
    return [[UIColor redColor] colorWithAlphaComponent:0.15];
}

#pragma mark - collectionViewDelegate/DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([DSHelper isArrayEmptyOrNil:(self.dataArray)]) {
        return 0;
    }
    return self.dataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SDMajletModel *group = self.dataArray[section];
    if ([DSHelper isArrayEmptyOrNil:(group.childApplications)]) {
        return 1;
    }
    return group.childApplications.count;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SDMajletModel *group = self.dataArray[indexPath.section];
        static NSString *headID = @"SDMajletCellHead";
        SDMajletCellHead *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headView.title = @"常用应用";
            if (group.edit == YES) {
                headView.rightBtn.hidden = YES;
            }else{
                headView.rightBtn.hidden = NO;
            }
            
        }else{
            headView.title = group.name;
            headView.rightBtn.hidden = YES;
        }
        __weak __typeof(self)weakSelf = self;
        headView.editBlock = ^(BOOL isEdit) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.editing = isEdit;
            if (strongSelf.block) {
                strongSelf.block(isEdit);
            }
        };
        return headView;
    }else{
        static NSString *footID = @"SDMajletCellFooter";
        SDMajletCellFooter *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footID forIndexPath:indexPath];
        return headView;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.dataArray.count) {
        SDMajletModel *group = self.dataArray[indexPath.section];
        if (indexPath.item < group.childApplications.count) {
            SDMajletModel *itemModel = group.childApplications[indexPath.row];
            static NSString *cellID = @"SDMajletCell";
            SDMajletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
            cell.font = 12;
            cell.iconName = itemModel.icon;
            cell.title = itemModel.name;
            cell.indexPath = indexPath;
            if (group.edit == YES ) {
                cell.editImgView.hidden = NO;
                if (indexPath.section == 0) {
                    cell.editImgView.image = [DSAwesomeKitTool imageNamed:@"wp_delete"];
                }else{
                    cell.editImgView.image = [DSAwesomeKitTool imageNamed:@"wp_add"];
                }
            }else{
                cell.editImgView.hidden = YES;
            }
            return cell;
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"default-cell" forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_hasSelect) {
        return;
    }
    _hasSelect = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_hasSelect = NO;
    });
    
    // 非编辑状态，
    if(!self.editing){
        if(self.didSelectItemAtIndexPath){
            self.didSelectItemAtIndexPath(indexPath);
        }
    } else {
        SDMajletModel *first_group = self.dataArray[0];
        SDMajletModel *group = self.dataArray[indexPath.section];
        if ([DSHelper isArrayEmptyOrNil:(group.childApplications)]) {
            return;;
        }
        SDMajletModel *itemModel = group.childApplications[indexPath.item];
        if (indexPath.section == 0) {
//            //只剩一个的时候不可删除
//            if ([_collectionView numberOfItemsInSection:0] == 1) {
//                return;
//            }
            [group.childApplications removeObject:itemModel];
            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
           
        } else {
            if (first_group.childApplications.count >= 10) {
                [DSHelper showAlertControllerWithTitle:nil message:@"最多添加10个常用功能" alertClick:nil];
                return;
            }
            if (![self hasContainsObject:itemModel]) {
                [first_group.childApplications  addObject:itemModel];
                [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0] ];
            } else {
                [DSHelper showAlertControllerWithTitle:nil message:@"该功能已加入到常用应用" alertClick:nil];
            }
          
        }

    }
}

/// 我的应用是否包含选中的应用
/// @param model model description
- (BOOL)hasContainsObject:(SDMajletModel *)model {
    BOOL has = NO;
    if (![DSHelper isArrayEmptyOrNil:(self.dataArray)]) {
        SDMajletModel *first_group = self.dataArray[0];
        if (![DSHelper isArrayEmptyOrNil:(first_group.childApplications)]) {
            for (SDMajletModel *subItem in first_group.childApplications) {
                if ([model.code isEqualToString:subItem.code]) {
                    has = YES;
                }
            }
        }
    }

    return has;
}

#pragma mark - 交换数组中的数据
-(void)uplogadInusesTitles{
    NSInteger section = _dragingFromindexPath.section;
    SDMajletModel *group = self.dataArray[section];
    id obj = [group.childApplications objectAtIndex:_dragingFromindexPath.row];
    [group.childApplications removeObject:obj];
    [group.childApplications insertObject:obj atIndex:_dragingToindexPaht.row];
}



/**
 回调方法返回上下数组
 
 @param block 代码块
 */
-(void)callBacktitlesBlock:(SDMajletBlock)block{
    
    _block = block;
    
//    _block(_inUseTitles,_unUseTitles);
    
}
-(void)reloadCollection{
    [_collectionView reloadData];
}


@end
