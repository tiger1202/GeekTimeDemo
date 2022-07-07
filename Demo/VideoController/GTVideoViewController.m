//
//  GTVideoViewController.m
//  Demo
//
//  Created by tiger on 2022/4/21.
//

#import "GTVideoViewController.h"
#import "GTVideoCoverView.h""

@interface GTVideoViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation GTVideoViewController

- (instancetype)init {
    if (self = [super init]) {
        self.tabBarItem.title = @"视频";
        self.tabBarItem.image = [UIImage imageNamed:@"resource/tabBar2_1@3x"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"resource/tabBar2_2@3x"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor blackColor];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;

    [collectionView registerClass:[GTVideoCoverView class] forCellWithReuseIdentifier:@"GTVideoCoverView"];
    
    [self.view addSubview:collectionView];
}

#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GTVideoCoverView" forIndexPath:indexPath];    // 当不存在cell时系统自动根据id创建cell
    if ([cell isKindOfClass:[GTVideoCoverView class]]) {
        [(GTVideoCoverView *)cell layoutWithVideoCoverURL:@"resource/videoPage.png"
                                           videoURLString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    }
    return cell;
}

#pragma mark - collectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item % 3 == 0) {
//        return CGSizeMake(self.view.bounds.size.width, 200);
//    } else {
//        return CGSizeMake((self.view.bounds.size.width - 10) / 2, 300);
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
