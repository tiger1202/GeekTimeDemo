//
//  QUILoadingViewController.m
//  Demo
//
//  Created by tiger on 2022/7/12.
//

#import "QUILoadingViewController.h"

static int colorCnt = 0;
static const CGFloat actionItemLen = 50.0;

@interface QUILoadingViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *actionScrollView;
@property (nonatomic, strong) UICollectionView *backgroundScrollView;
@property (nonatomic, copy) NSArray *colorArray;

@end

@implementation QUILoadingViewController

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
//    [self.view addSubview:self.actionScrollView];
//    [self.view addSubview:self.backgroundScrollView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = (self.view.frame.size.height - actionItemLen) / 2;
    layout.itemSize = CGSizeMake(actionItemLen, actionItemLen);
    layout.minimumInteritemSpacing = 20;
    
    
    CGFloat collectionViewHeight = 100.0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(actionItemLen, self.view.frame.size.height - collectionViewHeight / 2, self.view.frame.size.width, collectionViewHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = UIColor.whiteColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    // 当不存在cell时系统自动根据id创建cell
    cell.backgroundColor = [self.colorArray objectAtIndex:colorCnt % 3];
    colorCnt++;
    return cell;
}

- (NSArray *)colorArray {
    if (_colorArray == nil) {
        _colorArray = @[UIColor.redColor, UIColor.blueColor, UIColor.blackColor];
    }
    return _colorArray;
}

@end
