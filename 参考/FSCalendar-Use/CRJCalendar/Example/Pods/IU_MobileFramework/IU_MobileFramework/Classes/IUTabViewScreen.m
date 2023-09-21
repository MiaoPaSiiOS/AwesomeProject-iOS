//
//  IUTabViewScreen.m
//  CRJKit
//
//  Created by zhuyuhui on 2020/9/15.
//

#import "IUTabViewScreen.h"
@interface IUTabViewScreen ()
@property(nonatomic, strong) IUdZNEmptyView *dZNEmptyView;
@end

@implementation IUTabViewScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)iuInitSubviews {
    [super iuInitSubviews];
    if (!_recylerView) {
        UITableView *recylerView = [self preferredRecylerView];
        [recylerView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.iuView addSubview:recylerView];
        [recylerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appBar.mas_bottom);
            make.left.right.bottom.equalTo(recylerView.superview);
        }];
        self.recylerView = recylerView;
    }
}


#pragma mark - IUTableViewScreenProtocol
- (UITableView *)preferredRecylerView {
    UITableView *recylerView = [[UITableView alloc] initWithFrame:self.view.bounds style:[self preferredRecylerViewStyle]];
    recylerView.backgroundColor = [UIColor clearColor];
    recylerView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recylerView.delegate = self;
    recylerView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        recylerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        recylerView.estimatedRowHeight = 0;
        recylerView.estimatedSectionHeaderHeight = 0;
        recylerView.estimatedSectionFooterHeight = 0;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    return recylerView;
}

- (UITableViewStyle)preferredRecylerViewStyle {
    return UITableViewStylePlain;
}

- (void)showDZNEmptyView {
    if (self.dZNEmptyView) {
        [self hideDZNEmptyView];
    }
    [self.iuView addSubview:self.dZNEmptyView];
    [self.dZNEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appBar.mas_bottom);
        make.left.right.bottom.equalTo(self.dZNEmptyView.superview);
    }];
}

- (void)hideDZNEmptyView {
    if (self.dZNEmptyView) {
        [self.dZNEmptyView removeFromSuperview];
        self.dZNEmptyView = nil;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

///空置页
#pragma mark - DZNEmptyDataSetSource
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"empty_placeholder"];
//}
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"Please Allow Photo Access";
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"This allows you to share photos from your library and save photos to your camera roll.";
//
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
//                                 NSParagraphStyleAttributeName: paragraph};
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};

    return [[NSAttributedString alloc] initWithString:@"重新加载" attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    NSLog(@"%s",__FUNCTION__);
}




#pragma mark - getter setter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(IUdZNEmptyView *)dZNEmptyView {
    if (!_dZNEmptyView) {
        IUdZNEmptyView *emptView = [[IUdZNEmptyView alloc] initWithFrame:self.view.bounds];
        emptView.backgroundColor = [UIColor clearColor];
        emptView.recylerView.emptyDataSetSource = self;
        emptView.recylerView.emptyDataSetDelegate = self;
        _dZNEmptyView = emptView;
    }
    return _dZNEmptyView;
}

@end
