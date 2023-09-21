//
//  AmenChooseBgMusicScreen.m
//  AmenShootVideo
//
//  Created by zhuyuhui on 2021/6/22.
//

#import "AmenChooseBgMusicScreen.h"
#import "GKDYHeader.h"
@interface AmenChooseBgMusicScreen ()
@property(nonatomic,strong)NSArray * musicsArr;
@end

@implementation AmenChooseBgMusicScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择音乐";
    self.musicsArr = [self readAllMusicList];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicsArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * chooseID = @"gdfhrberxjtbnmnbyvr";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:chooseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseID];
    }
    cell.textLabel.text = self.musicsArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString * musicName = self.musicsArr[indexPath.row];
    NSLog(@"%@",musicName);
    [MAlertView showAlertIn:self msg:@"是否选择该背景音乐" callBack:^(BOOL sure) {
        if (sure) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(bgMusicChooseCallBack:)]) {
                [self.delegate bgMusicChooseCallBack:musicName];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(NSArray *)readAllMusicList
{
    NSArray * arr = @[
                      @"Aeolus (Original Mix) - Jeremy Lim",
                      @"Alpha - Christophe Lebled",
                      @"August Night - Martian",
                      @"Aurora - Capo Productions",
                      @"Black & White (Vinid Ambient Mix) - Vinid & Vla-D,The Great Voices of Bulgaria"
                      ];
    return arr;
}

@end
