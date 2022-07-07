//
//  GTRecommendViewController.m
//  Demo
//
//  Created by tiger on 2022/4/21.
//

#import "GTRecommendViewController.h"

@interface GTRecommendViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *touchView;

@end

@implementation GTRecommendViewController

- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor greenColor];
        self.tabBarItem.title = @"推荐";
        self.tabBarItem.image = [UIImage imageNamed:@"resource/tabBar3@3x"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.delegate = self;
    
    NSArray *colorArray = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor], [UIColor blackColor]];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 5, self.view.bounds.size.height);
    for (int i = 0; i < 5; i++) {
        [scrollView addSubview:({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * i, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
            view.backgroundColor = [colorArray objectAtIndex:i];
            view;
        })];
    }
    [scrollView addSubview:({
        self.touchView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
        self.touchView.backgroundColor = [UIColor yellowColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
        tapGesture.delegate = self;
        [self.touchView addGestureRecognizer:tapGesture];
        self.touchView;
    })];
    scrollView.pagingEnabled = NO;
    [self.view addSubview:scrollView];
}

#pragma mark - tapGesture
- (void)viewClick {
    NSLog(@"user is clicked");
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint tapPoint = [gestureRecognizer locationInView:self.touchView];   // 获取点击事件触发时，在添加手势的视图中点击的位置
    if (tapPoint.y < (self.touchView.frame.size.height / 2)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -UISCrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll - %@", @(scrollView.contentOffset.x));
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"BeginDragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"EndDragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
