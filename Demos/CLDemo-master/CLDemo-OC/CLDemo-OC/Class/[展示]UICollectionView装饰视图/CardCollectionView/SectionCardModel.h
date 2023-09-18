
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionCardModel : NSObject
/// 背景色
@property(nonatomic, strong) UIColor *backgroundColor;
/// 背景图
@property(nonatomic, strong) NSString *backgroundUrl;

@property(nonatomic, strong) NSArray *warfs;
@end

NS_ASSUME_NONNULL_END
