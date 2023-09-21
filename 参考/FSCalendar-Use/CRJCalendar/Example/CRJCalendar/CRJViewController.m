//
//  CRJViewController.m
//  CRJCalendar
//
//  Created by zhuyuhui434@gmail.com on 09/22/2020.
//  Copyright (c) 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import "CRJViewController.h"
#import <IU_Categories/IU_Categories.h>
#import <MJRefresh/MJRefresh.h>
#import <FSCalendar/FSCalendar.h>
#import <FSCalendar/FSCalendarExtensions.h>

#import "PACalendarCell.h"
#import "PACalendarStickyHeader.h"
#import "PACalendarWeekdayView.h"
#import "PACalendarMonthModel.h"


@interface CRJViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) PACalendarWeekdayView *weekdayView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (strong, nonatomic) NSCalendar *gregorian;
//@property (strong, nonatomic) NSDateFormatter *dateFormatter;
/// 设定每月第一周的第一天从星期几开始；1 代表星期日开始，2 代表星期一开始，以此类推。默认值是 1
@property (nonatomic, assign) NSUInteger firstWeekday;

@property (strong, nonatomic) NSMutableDictionary<NSDate *, PACalendarMonthModel *> *monthModels;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSDate *firstMonthDate;

@property (nonatomic, strong) NSDate *minMonthDate;

@property(nonatomic, assign) BOOL isRequesting;

@property (strong, nonatomic) NSMutableDictionary *datesWithEvent;
@end

@implementation CRJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDatas];
    
    [self initSubViews];
    
    [self fetchCurrentMonth];
}

- (void)initDatas {
    self.isRequesting = NO;
    self.dataSource = [NSMutableArray array];
    self.datesWithEvent = [NSMutableDictionary dictionary];
    self.monthModels = [NSMutableDictionary dictionary];
    
    self.firstWeekday = 1;
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.gregorian.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.gregorian.firstWeekday = self.firstWeekday;
    
    self.firstMonthDate = [NSDate date];
    //设置最大可查询时间[]
    self.minMonthDate = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-24 toDate:[NSDate date] options:0];
    
    
    // 默认显示当月
    [self.dataSource addObject:[self createMonthInMonth:self.firstMonthDate]];

}

- (void)initSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"按日期查找";
    
    self.weekdayView = [[PACalendarWeekdayView alloc] initWithFrame:CGRectMake(0, [self getAppBarHeight], self.view.fs_width, 40)];
    self.weekdayView.gregorian = self.gregorian;
    self.weekdayView.firstWeekday = self.firstWeekday;
    [self.weekdayView configureAppearance];
    [self.view addSubview:self.weekdayView];
    
    
    float cellw = floor(self.view.fs_width/7) - 3;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(cellw, 40)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.fs_width, 40)];
    [flowLayout setMinimumInteritemSpacing:0]; //设置 y 间距
    [flowLayout setMinimumLineSpacing:0]; //设置 x 间距
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 10, 0);//设置其边界
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weekdayView.frame), self.view.fs_width, self.view.fs_height - CGRectGetMaxY(self.weekdayView.frame)) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 注册cell
    [_collectionView registerClass:[PACalendarCell class] forCellWithReuseIdentifier:FSCalendarDefaultCellReuseIdentifier];
    [_collectionView registerClass:[PACalendarBlankCell class] forCellWithReuseIdentifier:FSCalendarBlankCellReuseIdentifier];
    [_collectionView registerClass:[PACalendarStickyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:_collectionView];
    
    
    __weak __typeof(self)weakSelf = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRequesting) {
            [self->_collectionView.mj_header endRefreshing];
            return;
        }
        [weakSelf fetchMoreMonth];
    }];
}

#pragma mark - request
// 查询当前月聊天记录
- (void)fetchCurrentMonth {
    // 当前月
    PACalendarMonthModel *monthModel = self.dataSource.firstObject;
    
    NSDate *begin = [self fs_firstDayOfMonth:monthModel.date day:1];//本月第一天
    NSDate *end = [self fs_firstDayOfMonth:monthModel.date day:monthModel.numberOfDaysInMonth];//本月最后一天
        
    __weak __typeof(self)weakSelf = self;
    [self startLoading];
    [self fetchChatMsgCountByDayWithBeginTime:[begin timeIntervalSince1970]*1000 endTime:[end timeIntervalSince1970]*1000 callback:^(NSString *code, id data) {
        [self stopLoading];
        if ([code isEqualToString:@"000000"]) {
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                // 数据处理
                [weakSelf exchangeDatas:data];
                [weakSelf.collectionView reloadData];
            }
            
        } else {

        }
        weakSelf.isRequesting = NO;
        
    }];
}

// 在firstMonthDate基础上往前查5个月的；
- (void)fetchMoreMonth {
    NSMutableArray <PACalendarMonthModel *>*months = [NSMutableArray array];
    for (int i = 1; i <= 5; i++) {
        PACalendarMonthModel *monthModel = [self createMonthInMonth:[self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-i toDate:self.firstMonthDate options:0]];
        [months insertObject:monthModel atIndex:0];
    }
    
    /// 删选，把超过可查询时间的月份删除
    NSMutableArray *del = [NSMutableArray array];
    for (PACalendarMonthModel *month in months) {
        FSCalendarMonthPosition comparison = [self compareDate:month.date toDate:self.minMonthDate];
        if (comparison == FSCalendarMonthPositionPrevious) {
            [del addObject:month];
        }
    }
    [months removeObjectsInArray:del];
    if (months.count == 0) {
        [IUHUD alertTextOnly:@"超出最大查询日期！" inView:self.view];
        [self.collectionView.mj_header endRefreshing];
        return;
    }
    
    
    
    NSDate *begin = [self fs_firstDayOfMonth:months.firstObject.date day:1];//本月第一天
    NSDate *end = [self fs_firstDayOfMonth:months.lastObject.date day:months.lastObject.numberOfDaysInMonth];//本月最后一天
    
    __weak __typeof(self)weakSelf = self;
    [self startLoading];
    [self fetchChatMsgCountByDayWithBeginTime:[begin timeIntervalSince1970]*1000 endTime:[end timeIntervalSince1970]*1000 callback:^(NSString *code, id data) {
        [self stopLoading];
        [weakSelf.collectionView.mj_header endRefreshing];
        if ([code isEqualToString:@"000000"]) {
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                /// 先添加Model
                NSArray *arr = [[months reverseObjectEnumerator] allObjects];
                for (PACalendarMonthModel *monthModel in arr) {
                    [weakSelf.dataSource insertObject:monthModel atIndex:0];
                }
                
                
                // 数据处理
                [weakSelf exchangeDatas:data];
                [weakSelf.collectionView reloadData];
                
                // 滑动到未查看的最近的月份
                [weakSelf scrollToMonth:[weakSelf.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:weakSelf.firstMonthDate options:0]];
                
                 weakSelf.firstMonthDate = begin;
            }
            
        } else {
            [IUHUD alertTextOnly:@"信息加载失败，请稍后重试" inView:weakSelf.view];
        }
        weakSelf.isRequesting = NO;
    }];
}

- (void)fetchChatMsgCountByDayWithBeginTime:(long)beginTime
                                    endTime:(long)endTime
                                   callback:(void(^)(NSString *code, id data))callback
{
    self.isRequesting = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callback) {
            callback(@"000000",@{});
        }
    });
}

- (void)exchangeDatas:(NSDictionary *)extraInfoDic {
    if (extraInfoDic[@"msgCountList"] && [extraInfoDic[@"msgCountList"] isKindOfClass:[NSArray class]]) {
        NSArray *msgCountList = extraInfoDic[@"msgCountList"] ?:@[];
        for (NSDictionary *dic in msgCountList) {
            NSString *dateString = dic[@"dateString"];
            long count = [dic[@"count"] longValue];
            
            if (dateString && count > 0) {
                [self.datesWithEvent setValue:dic forKey:dateString];
            }
        }
    }

    for (PACalendarMonthModel *month in self.dataSource) {
        for (PACalendarDayModel *day in month.headDays) {
            NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
            NSDate *date = day.date;
            [formater setDateFormat:@"yyyy-MM-dd"];
            NSString * time = [formater stringFromDate:date];
//            NSLog(@"%@",time);

            if ([self.datesWithEvent.allKeys containsObject:time]) {
                day.hasEvent = YES;
            } else {
                day.hasEvent = NO;
            }
        }
    }
}



#pragma mark - 创建月份Model
- (PACalendarMonthModel *)createMonthInMonth:(NSDate *)month
{
    if (!month) return nil;
    PACalendarMonthModel *monthModel = self.monthModels[month];
    if (monthModel == nil) {
        NSDate *firstDayOfMonth = [self.gregorian fs_firstDayOfMonth:month];
        NSInteger weekdayOfFirstDay = [self.gregorian component:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
        NSInteger numberOfDaysInMonth = [self.gregorian fs_numberOfDaysInMonth:month];
        NSInteger numberOfPlaceholdersForPrev = ((weekdayOfFirstDay - self.gregorian.firstWeekday) + 7) % 7;
        NSInteger headDayCount = numberOfDaysInMonth + numberOfPlaceholdersForPrev;
        NSInteger numberOfRows = (headDayCount/7) + (headDayCount%7>0);
        
        monthModel = [[PACalendarMonthModel alloc] init];
        monthModel.date = month;
        monthModel.numberOfDaysInMonth = numberOfDaysInMonth;
        monthModel.numberOfPlaceholdersForPrev = numberOfPlaceholdersForPrev;
        monthModel.headDayCount = headDayCount;
        monthModel.numberOfRows = numberOfRows;
        monthModel.headDays = [NSMutableArray array];
        
        
        for (int i = 0; i < numberOfPlaceholdersForPrev; i++) {
            PACalendarDayModel *day = [[PACalendarDayModel alloc] init];
            [monthModel.headDays addObject:day];
        }
        
        for (int i = 1; i <= numberOfDaysInMonth; i++) {
            PACalendarDayModel *day = [[PACalendarDayModel alloc] init];
            day.title = [NSString stringWithFormat:@"%d",i];
            day.date = [self fs_firstDayOfMonth:month day:i];
            if ([self.gregorian isDateInToday:day.date]) {
                day.dateIsToday = YES;
                day.selected = YES;
            }
            [monthModel.headDays addObject:day];
        }
        
        self.monthModels[month] = monthModel;
        
    }
    return monthModel;
}

#pragma mark - Useful Method
// 获取指定月份某天对应的日期
- (NSDate *)fs_firstDayOfMonth:(NSDate *)month day:(NSInteger)day {
    if (!month) return nil;
    NSDateComponents *components = [self.gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.day = day;
    return [self.gregorian dateFromComponents:components];
}

// 比较月份大小
- (FSCalendarMonthPosition)compareDate:(NSDate *)date1 toDate:(NSDate *)date2
{
    NSComparisonResult comparison = [self.gregorian compareDate:date1 toDate:date2 toUnitGranularity:NSCalendarUnitMonth];
    switch (comparison) {
        case NSOrderedAscending:
            return FSCalendarMonthPositionPrevious;
        case NSOrderedSame:
            return FSCalendarMonthPositionCurrent;
        case NSOrderedDescending:
            return FSCalendarMonthPositionNext;
    }
}

// 滚动到指定月份
- (void)scrollToMonth:(NSDate *)month {
    for (PACalendarMonthModel *monthModel in self.dataSource) {
        if ([self compareDate:month toDate:monthModel.date] == FSCalendarMonthPositionCurrent) {
            NSInteger index = [self.dataSource indexOfObject:monthModel];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
    }
}



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark --- <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    PACalendarMonthModel *monthModel = self.dataSource[section];
    return monthModel.headDays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PACalendarMonthModel *monthModel = self.dataSource[indexPath.section];
    PACalendarDayModel *model = monthModel.headDays[indexPath.row];
    if (!model.date) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:FSCalendarBlankCellReuseIdentifier forIndexPath:indexPath];
    }
    
    PACalendarCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:FSCalendarDefaultCellReuseIdentifier forIndexPath:indexPath];
    cell.model = model;
    [cell configureAppearance];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PACalendarStickyHeader * headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        PACalendarMonthModel *monthModel = self.dataSource[indexPath.section];
        
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        NSDate *date = monthModel.date;
        [formater setDateFormat:@"yyyy年MM月"];
        NSString * time = [formater stringFromDate:date];

        headerCell.titleLabel.text = [NSString stringWithFormat:@"   %@",time];
        headerCell.titleLabel.textColor = [UIColor colorWithHexString:@"#979797"];
        headerCell.titleLabel.font = [UIFont systemFontOfSize:13];
        headerCell.titleLabel.textAlignment = NSTextAlignmentLeft;
        return headerCell;
    }
    return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PACalendarMonthModel *monthModel = self.dataSource[indexPath.section];
    PACalendarDayModel *model = monthModel.headDays[indexPath.row];
    if (model.hasEvent) {
        return YES;
    }
    return NO;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PACalendarMonthModel *monthModel = self.dataSource[indexPath.section];
    PACalendarDayModel *model = monthModel.headDays[indexPath.row];
    if (model.date) {
        NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
        NSDate *date = model.date;
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSString * time = [formater stringFromDate:date];
        NSLog(@"%@",time);
        
        for (PACalendarMonthModel *month in self.dataSource) {
            for (PACalendarDayModel *day in month.headDays) {
                day.selected = NO;
                if ([model.date isEqualToDate:day.date]) {
                    day.selected = YES;
                }
            }
        }
        [self.collectionView reloadData];
        
    }
}

@end

