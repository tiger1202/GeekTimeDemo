//
//  GTNormalTableViewCell.m
//  Demo
//
//  Created by tiger on 2022/4/25.
//

#import "GTNormalTableViewCell.h"
#import "GTListItem.h"
#import <SDWebImage.h>

@interface GTNormalTableViewCell ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *sourceLable;
@property (nonatomic, strong) UILabel *commentLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation GTNormalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:({
            self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 270, 50)];
            self.titleLable.font = [UIFont systemFontOfSize:16];
            self.titleLable.textColor = [UIColor blackColor];
            self.titleLable.numberOfLines = 2; // 显示行数大小
            self.titleLable.lineBreakMode = NSLineBreakByTruncatingTail; // 截断方式，以尾部...截断
            self.titleLable;
        })];
        
        [self.contentView addSubview:({
            self.sourceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 50, 20)];
            self.sourceLable.font = [UIFont systemFontOfSize:12];
            self.sourceLable.textColor = [UIColor grayColor];
            self.sourceLable;
        })];
        
        [self.contentView addSubview:({
            self.commentLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 50, 20)];
            self.commentLable.font = [UIFont systemFontOfSize:12];
            self.commentLable.textColor = [UIColor grayColor];
            self.commentLable;
        })];
        
        [self.contentView addSubview:({
            self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, 50, 20)];
            self.timeLable.font = [UIFont systemFontOfSize:12];
            self.timeLable.textColor = [UIColor grayColor];
            self.timeLable;
        })];
        
        [self.contentView addSubview:({
            self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 15, 100, 70)];
            self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightImageView;
        })];
        
//        [self.contentView addSubview:({
//            self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 80, 30, 20)];
//            [self.deleteButton setTitle:@"X" forState:UIControlStateNormal];
//            [self.deleteButton setTitle:@"V" forState:UIControlStateSelected];
//
//            self.deleteButton.layer.cornerRadius = 10; // 给layer加圆角
//            self.deleteButton.layer.masksToBounds = YES; // 指视图的图层上的子图层,如果超出父图层的部分就截取掉
//
//            self.deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//            self.deleteButton.layer.borderWidth = 2;
//
//            [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            self.deleteButton;
//        })];
    }
    return self;
}

- (void)tagReadItem:(GTListItem *)item {
    BOOL hasRead = NO;
    NSArray *readItemUniquekeyArray = [[NSUserDefaults standardUserDefaults] objectForKey:readItemArrayKey];
    for (NSString *itemUniqueKey in readItemUniquekeyArray) {
        if ([itemUniqueKey isEqualToString:item.uniqueKey]) {
            hasRead = YES;
        }
    }
    if (hasRead) {
        self.titleLable.textColor = [UIColor lightGrayColor];
    } else {
        self.titleLable.textColor = [UIColor blackColor];
    }
}

- (void)layoutTableViewCellWithItem:(GTListItem *)item {
    self.titleLable.text = item.title;
    [self tagReadItem:item];
    
    self.sourceLable.text = item.authorName;
    [self.sourceLable sizeToFit];
    
    self.commentLable.text = item.category;
    [self.commentLable sizeToFit];
    self.commentLable.frame = CGRectMake(self.sourceLable.frame.origin.x + self.sourceLable.frame.size.width + 15, self.sourceLable.frame.origin.y, self.commentLable.frame.size.width, self.commentLable.frame.size.height);
    
    self.timeLable.text = item.date;
    [self.timeLable sizeToFit];
    self.timeLable.frame = CGRectMake(self.commentLable.frame.origin.x + self.commentLable.frame.size.width + 15, self.commentLable.frame.origin.y, self.timeLable.frame.size.width, self.timeLable.frame.size.height);
    
//    // GCD 非主队列从网络下载图片的实现
//    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(downloadQueue, ^{
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.picUrl]]];
//        dispatch_async(mainQueue, ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            strongSelf.rightImageView.image = image;
//        });
//    });
    
    // 使用SDWenImage开源库下载网络图片
    [self.rightImageView sd_setImageWithURL:item.picUrl];
}

#pragma mark - GTNormalTableViewCellDelegate
- (void)deleteButtonClick {
    self.deleteButton.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:clickDeleteButton:)]) {
        [self.delegate tableViewCell:self clickDeleteButton:self.deleteButton];
    }
}

@end
