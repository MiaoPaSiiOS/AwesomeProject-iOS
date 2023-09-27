//
//  FeedappChildTwitterViewScreen.m
//  AmenFeed
//
//  Created by zhuyuhui on 2021/6/19.
//

#import "FeedappChildTwitterViewScreen.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <YYModel/YYModel.h>
#import <MJRefresh/MJRefresh.h>

#import "T1StatusLayout.h"
#import "T1StatusCell.h"
#import "AmenFeedTool.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"
#import "AULoadErrorView.h"
#import "AUMoreFailedView.h"
#import "FeedappNetRequest.h"


@interface FeedappChildTwitterViewScreen ()<T1StatusCellDelegate>
//列表数据数组
@property(nonatomic, strong) NSMutableArray *dataArray;
//当前页，从0开始
@property(nonatomic, assign) NSInteger currentCount;
//正在请求，防止重复请求
@property(nonatomic, assign) BOOL isRequesting;
//是否没有更多
@property(nonatomic, assign) BOOL isNoMore;
//请求错误页面
@property(nonatomic, strong) AULoadErrorView *errorView;
//列表为空页面
@property(nonatomic, strong) AULoadErrorView *emptyView;
//加载更多失败页面
@property(nonatomic, strong) AUMoreFailedView *moreFailedView;
//帧率检测
@property(nonatomic, strong) YYFPSLabel *fpsLabel;


@end

@implementation FeedappChildTwitterViewScreen
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.appBar.hidden = YES;
    self.enableRefresh = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
    }];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.fpsLabel];
    
    [self initialRequest];
}



- (void)initialRequest {
    self.currentCount = 0;
    self.isRequesting = NO;
    self.isNoMore = NO;
    self.errorView.hidden = YES;
    self.emptyView.hidden = YES;
    self.recylerView.mj_footer.hidden = YES;
    self.recylerView.tableFooterView = [UIView new];
    
    [self.recylerView.mj_header beginRefreshing];
}

- (void)headerRefreshAction {
    [self requestData];
}

- (void)footerRefreshAction {
    [self requestData];
}

#pragma mark 请求数据
- (void)requestData {
    if (self.isRequesting) {
        return;
    }
    kWeakSelf
    self.isRequesting = YES;
    
    NSString *path = [NSString stringWithFormat:@"json/result_%ld.json",self.currentCount];
    [FeedappNetRequest achieveJSONDataWithPath:path branch:@"Twitter" completeHandler:^(BOOL success, NSDictionary *responseObject) {
        kStrongSelf
        if (strongSelf.currentCount == 0) {
            [strongSelf.dataArray removeAllObjects];
        }
        if (!success) {
            if (strongSelf.currentCount == 0) {
                //第一页加载失败
                strongSelf.errorView.hidden = NO;
                strongSelf.emptyView.hidden = YES;
            }
            else{
                strongSelf.recylerView.mj_footer.hidden = YES;
                strongSelf.recylerView.tableFooterView = self.moreFailedView;
            }
            [strongSelf.recylerView reloadData];
            [strongSelf stopRefresh];
        }else{
            NSMutableArray *muArray = [NSMutableArray array];
            T1APIRespose *response = [T1APIRespose yy_modelWithDictionary:responseObject];
            for (id item in response.timelineItmes) {
                if ([item isKindOfClass:[T1Tweet class]]) {
                    T1Tweet *tweet = item;
                    T1StatusLayout *layout = [T1StatusLayout new];
                    layout.tweet = tweet;
                    [muArray addObject:layout];
                } else if ([item isKindOfClass:[T1Conversation class]]) {
                    T1Conversation *conv = item;
                    NSMutableArray *convLayouts = [NSMutableArray new];
                    for (T1Tweet *tweet in conv.tweets) {
                        T1StatusLayout *layout = [T1StatusLayout new];
                        layout.conversation = conv;
                        layout.tweet = tweet;
                        [convLayouts addObject:layout];
                    }
                    if (conv.targetCount > 0 && convLayouts.count >= 2) {
                        T1StatusLayout *split = [T1StatusLayout new];
                        split.conversation = conv;
                        [split layout];
                        [convLayouts insertObject:split atIndex:1];
                    }
                    [muArray addObjectsFromArray:convLayouts];
                }
            }
            
            if (muArray.count == 0 && strongSelf.currentCount == 0) {
                //空页面
                strongSelf.isNoMore = YES;
                strongSelf.errorView.hidden = YES;
                strongSelf.emptyView.hidden = NO;
                strongSelf.recylerView.mj_footer.hidden = YES;
                [strongSelf.recylerView reloadData];
            }else{
                //正常页面显示
                strongSelf.errorView.hidden = YES;
                strongSelf.emptyView.hidden = YES;
                                    
                if (muArray.count > 0) {
                    strongSelf.isNoMore = NO;
                    [strongSelf.dataArray addObjectsFromArray:muArray];
                    strongSelf.currentCount += 1;
                    strongSelf.recylerView.mj_footer.hidden = NO;
                    [strongSelf.recylerView reloadData];
                }
                else{
                    //没有更多
                    [strongSelf.dataArray addObjectsFromArray:muArray];
                    strongSelf.isNoMore = YES;
                    strongSelf.currentCount += 1;
                    strongSelf.recylerView.mj_footer.hidden = YES;
                    [strongSelf setMoreFooterView];
                    [strongSelf.recylerView reloadData];
                }
            }
            [strongSelf stopRefresh];
        }
        strongSelf.isRequesting = NO;
    }];
}

//没有更多了
- (void)setMoreFooterView{
    [self noMoreData];
}

#pragma mark - 没有更多页面
- (void)noMoreData{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DSCommonMethods.screenWidth, (50))];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:view.frame];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"没有更多啦";
    titleLabel.textColor = [DSCommonMethods colorWithHexString:@"0x000000"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [view addSubview:titleLabel];
    self.recylerView.tableFooterView = view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cell";
    T1StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[T1StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    if (indexPath.row < self.dataArray.count) {
        [cell setLayout:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((T1StatusLayout *)self.dataArray[indexPath.row]).height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - T1StatusCellDelegate

- (void)cell:(T1StatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    YYTextHighlight *highlight = [label.textLayout.text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    NSURL *link = nil;
    NSString *linkTitle = nil;
    if (info[@"T1URL"]) {
        T1URL *url = info[@"T1URL"];
        if (url.expandedURL.length) {
            link = [NSURL URLWithString:url.expandedURL];
            linkTitle = url.displayURL;
        }
    } else if (info[@"T1Media"]) {
        T1Media *media = info[@"T1Media"];
        if (media.expandedURL.length) {
            link = [NSURL URLWithString:media.expandedURL];
            linkTitle = media.displayURL;
        }
    }
    if (link) {

    }
}

- (void)cell:(T1StatusCell *)cell didClickImageAtIndex:(NSUInteger)index withLongPress:(BOOL)longPress {
    if (longPress) {
        // show alert
        return;
    }
    UIImageView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    NSArray<T1Media *> *images = cell.layout.images;

    for (NSUInteger i = 0, max = images.count; i < max; i++) {
        UIImageView *imgView = cell.statusView.mediaView.imageViews[i];
        T1Media *img = images[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = img.mediaLarge.url;
        item.largeImageSize = img.mediaLarge.size;
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }

    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

- (void)cell:(T1StatusCell *)cell didClickQuoteWithLongPress:(BOOL)longPress {
    
}

- (void)cell:(T1StatusCell *)cell didClickAvatarWithLongPress:(BOOL)longPress {
    
}

- (void)cell:(T1StatusCell *)cell didClickContentWithLongPress:(BOOL)longPress {
    
}

- (void)cellDidClickReply:(T1StatusCell *)cell {
    
}

- (void)cellDidClickRetweet:(T1StatusCell *)cell {
    T1StatusLayout *layout = cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.retweeted) {
        tweet.retweeted = NO;
        if (tweet.retweetCount > 0) tweet.retweetCount--;
        layout.retweetCountTextLayout = [layout retweetCountTextLayoutForTweet:tweet];
    } else {
        tweet.retweeted = YES;
        tweet.retweetCount++;
        layout.retweetCountTextLayout = [layout retweetCountTextLayoutForTweet:tweet];
    }
    [cell.statusView.inlineActionsView updateRetweetWithAnimation];
}

- (void)cellDidClickFavorite:(T1StatusCell *)cell {
    T1StatusLayout *layout = cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    if (tweet.favorited) {
        tweet.favorited = NO;
        if (tweet.favoriteCount > 0) tweet.favoriteCount--;
        layout.favoriteCountTextLayout = [layout favoriteCountTextLayoutForTweet:tweet];
    } else {
        tweet.favorited = YES;
        tweet.favoriteCount++;
        layout.favoriteCountTextLayout = [layout favoriteCountTextLayoutForTweet:tweet];
    }
    [cell.statusView.inlineActionsView updateFavouriteWithAnimation];
}

- (void)cellDidClickFollow:(T1StatusCell *)cell {
    T1StatusLayout *layout = cell.layout;
    T1Tweet *tweet = layout.displayedTweet;
    tweet.user.following = !tweet.user.following;
    [cell.statusView.inlineActionsView updateFollowWithAnimation];
}


#pragma mark - 错误页面
- (AULoadErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[AULoadErrorView alloc] initWithFrame:self.recylerView.bounds];
        _errorView.type = AULoadServerError;
        kWeakSelf
        [_errorView setRefreshHandle:^(AULoadErrorView *loadErrorView) {
            kStrongSelf
            [strongSelf initialRequest];
        }];
        [self.dsView addSubview:_errorView];
    }
    return _errorView;
}
#pragma mark - 空页面
- (AULoadErrorView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[AULoadErrorView alloc] initWithFrame:self.recylerView.bounds];
        _errorView.type = AULoadNoData;
        [self.dsView addSubview:_errorView];
    }
    return _emptyView;
}
#pragma mark - 加载更多失败
- (AUMoreFailedView *)moreFailedView{
    if (!_moreFailedView) {
        _moreFailedView = [[AUMoreFailedView alloc] initWithFrame:CGRectMake(0, 0, DSCommonMethods.screenWidth, 68)];
        kWeakSelf
        [_moreFailedView setRetryBlock:^{
            kStrongSelf
            [strongSelf.recylerView setTableFooterView:nil];
            strongSelf.recylerView.mj_footer.hidden = NO;
            [strongSelf.recylerView.mj_footer beginRefreshing];
        }];
    }
    return _moreFailedView;
}

- (YYFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [YYFPSLabel new];
        [_fpsLabel sizeToFit];
        _fpsLabel.top = 12;
        _fpsLabel.left = 12;
        _fpsLabel.alpha = 0;
    }
    return _fpsLabel;
}
@end
