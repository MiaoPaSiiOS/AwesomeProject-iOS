
#import "CLDBKPDDViewController.h"
#import "CoverViewer.h"
@interface CLDBKPDDViewController ()<CoverViewerDelegate>
@property(nonatomic,strong) CoverViewer *coverViewer;//滚动视图动画
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UIView *detailView;
@property(nonatomic,strong) UILabel *nameLabe;
@end

@implementation CLDBKPDDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新品";
    self.view.backgroundColor = UIColor.orangeColor;
    [self getData];
    self.coverViewer = [[CoverViewer alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 224)];
    self.coverViewer.delegate = self;
    self.coverViewer.backgroundColor = [UIColor clearColor];
    self.coverViewer.rightLimit = [UIScreen mainScreen].bounds.size.width/166;
    [self.view addSubview:self.coverViewer];
    
    self.coverViewer.layer.borderColor = [UIColor redColor].CGColor;
    self.coverViewer.layer.borderWidth = 2;
    
    self.detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 450, [UIScreen mainScreen].bounds.size.width, 80)];
    self.detailView.backgroundColor = UIColor.purpleColor;
    [self.view addSubview:self.detailView];
    
    self.nameLabe = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 40)];
    self.nameLabe.textColor = UIColor.whiteColor;
    self.nameLabe.font = [UIFont systemFontOfSize:15];
    self.nameLabe.text = [self.dataArray[0]objectForKey:@"title"];

    [self.detailView addSubview:self.nameLabe];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getData{
    NSArray *arr = @[@{@"imageName":@"cover0.jpg",@"title":@"第1张"},@{@"imageName":@"cover1.jpg",@"title":@"第2张"},@{@"imageName":@"cover2.jpg",@"title":@"第3张"},@{@"imageName":@"cover3.jpg",@"title":@"第4张"},@{@"imageName":@"cover4.jpg",@"title":@"第5张"}];
    for (int i = 0; i<5; i++) {
        NSDictionary *dic = arr[i];
        
        [self.dataArray addObject:dic];
    }
    [self.coverViewer reloadDatas];

}

#pragma mark - CoverViewerDelegate
- (NSInteger)coverViewerCount:(CoverViewer *)coverViewer{
    return self.dataArray.count;
}

- (UIImageView *)coverViewer:(CoverViewer*)coverViewer coverAtIndex:(NSInteger)index {
    UIImageView *view = [coverViewer dequeueItemView];
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 150, 224)];
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
        [view addGestureRecognizer:tap];
        view.userInteractionEnabled = YES;
    }
    view.tag = index;
    //这个地方可以加载网络图片
    [view setImage:[UIImage imageNamed:[self.dataArray[index]objectForKey:@"imageName"]]];
//    [view sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"loadingplacehi"]];

    return view;
}

- (void)itemClicked:(UITapGestureRecognizer *)tap {
    [_coverViewer setContentOffset:tap.view.tag animated:YES];
    UIImageView *view = (UIImageView *)tap.view;
    NSLog(@"%ld",view.tag);

//    self.currentScrollIndex = tap.view.tag;
//    MahuaHotItemMovieModel *model = self.movieArray[tap.view.tag];
    if (view.frame.size.width == 150 && view.frame.size.height == 224) {
        //点击的时候判断尺寸 根据尺寸来判断是否点击了最大的图片
        NSLog(@"点击了最大的图片");

    }else{
      //如果不是最大的 就做UI上的处理 （改变ui尺寸 等等）
        self.nameLabe.text = [self.dataArray[view.tag]objectForKey:@"title"];
    }
}

-(void)passCurrentScrollIndex:(NSInteger)currentIndex{
    NSLog(@"%ld",currentIndex);
    self.nameLabe.text = [self.dataArray[currentIndex]objectForKey:@"title"];
}


-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

@end
