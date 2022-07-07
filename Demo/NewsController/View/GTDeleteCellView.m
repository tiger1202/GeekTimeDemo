//
//  GTDeleteCellView.m
//  Demo
//
//  Created by tiger on 2022/5/9.
//

#import "GTDeleteCellView.h"

@interface GTDeleteCellView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, copy) dispatch_block_t deleteBlock;
@property (nonatomic, strong) UIButton *cellDeleteButton;

@end

@implementation GTDeleteCellView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:({
            self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
            self.backgroundView.backgroundColor = [UIColor grayColor];
            self.backgroundView.alpha = 0.5f;
            [self.backgroundView addGestureRecognizer:({
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDeleteView)];
                tapGesture;
            })];
            self.backgroundView;
        })];
        
        [self addSubview:({
            self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            self.deleteButton.backgroundColor = [UIColor blueColor];
            [self.deleteButton addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
            self.deleteButton;
        })];
    }
    return self;
}

- (void)showDeleteViewFromPoint:(CGPoint)point clickBlock:(dispatch_block_t)block cellDeleteButton:(UIButton *)cellDeleteButton {
    self.cellDeleteButton = cellDeleteButton;
    
    self.deleteButton.frame = CGRectMake(point.x, point.y, 0, 0);
    self.deleteBlock = [block copy];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:1.f
                          delay:0.f
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
            self.deleteButton.frame = CGRectMake((self.bounds.size.width - 200) / 2, (self.bounds.size.height - 200) / 2, 200, 200);
        }
                     completion:^(BOOL finished) {
            // 动画结束后执行
        }
    ];
}

- (void)dismissDeleteView {
    self.cellDeleteButton.selected = NO;
    [self removeFromSuperview];
}

- (void)_clickButton {
    if (_deleteBlock) {
        _deleteBlock();
    }
    [self dismissDeleteView];
}



@end
