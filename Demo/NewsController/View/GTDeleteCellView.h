//
//  GTDeleteCellView.h
//  Demo
//
//  Created by tiger on 2022/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTDeleteCellView : UIView

- (void)showDeleteViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t)block cellDeleteButton:(UIButton *)cellDeleteButton;
- (void)dismissDeleteView;

@end

NS_ASSUME_NONNULL_END
