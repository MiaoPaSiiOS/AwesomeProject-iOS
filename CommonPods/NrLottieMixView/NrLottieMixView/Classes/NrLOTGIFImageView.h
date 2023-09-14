//
//  NrLOTGIFImageView.h
//  NrLottieMixView
//
//  Created by zhuyuhui on 2023/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NrLOTGIFImageView : UIView
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, strong) UIImage *image; // default is nil
@end

NS_ASSUME_NONNULL_END
