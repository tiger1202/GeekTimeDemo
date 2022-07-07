//
//  GTNormalTableViewCell.h
//  Demo
//
//  Created by tiger on 2022/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *readItemArrayKey = @"readedArray";

@class GTListItem;

/**
 点击删除按钮
 */
@protocol GTNormalTableViewCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)cell clickDeleteButton:(UIButton *)deleteButton;

@end

/**
新闻列表cell
 */
@interface GTNormalTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<GTNormalTableViewCellDelegate> delegate; // weak防止循环引用

- (void)layoutTableViewCellWithItem:(GTListItem *)item;
- (void)tagReadItem:(GTListItem *)item; // 标记已读列表单元格

@end

NS_ASSUME_NONNULL_END
