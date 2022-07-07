//
//  GTVideoCoverView.h
//  Demo
//
//  Created by tiger on 2022/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTVideoCoverView : UICollectionViewCell

- (void)layoutWithVideoCoverURL:(NSString *)coverURL videoURLString:(NSString *)videoURLString;

@end

NS_ASSUME_NONNULL_END
