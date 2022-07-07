//
//  ViewController.m
//  Demo
//
//  Created by tiger on 2022/4/13.
//

#import "GTNewsViewController.h"
#import "GTNormalTableViewCell.h"
#import "GTDetailViewController.h"
#import "GTDeleteCellView.h"
#import "GTListLoader.h"
#import "GTListItem.h"

@interface GTNewsViewController () <UITableViewDataSource, UITableViewDelegate, GTNormalTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) GTListLoader *listLoader;

@end

@implementation GTNewsViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.listLoader = [GTListLoader new];
    
    __weak typeof(self)weakSelf = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<GTListItem *> * _Nonnull dataArray) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataArray = dataArray;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[GTNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.delegate = self;
    }
    [cell layoutTableViewCellWithItem:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTListItem *item = [self.dataArray objectAtIndex:indexPath.row];
    GTDetailViewController *controller = [[GTDetailViewController alloc] initWithURLString:item.articleUrl];
    controller.title = [NSString stringWithFormat:@"%ld", indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    
    // 存储已读列表并更新列表单元格的标题颜色
    NSMutableArray *readNumberArray = [[[NSUserDefaults standardUserDefaults] objectForKey:readItemArrayKey] mutableCopy];
    if (!readNumberArray) {
        readNumberArray = [NSMutableArray new];
    }
    [readNumberArray addObject:item.uniqueKey];
    [[NSUserDefaults standardUserDefaults] setObject:readNumberArray.copy forKey:readItemArrayKey];
    [(GTNormalTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] tagReadItem:item];
}

#pragma mark - GTNormalTableViewCellDelegate
- (void)tableViewCell:(UITableViewCell *)cell clickDeleteButton:(UIButton *)deleteButton {
//    CGPoint point = [cell convertPoint:deleteButton.frame.origin toView:nil];
//    point.x += deleteButton.bounds.size.width / 2;
//    point.y += deleteButton.bounds.size.height / 2;
//
//    GTDeleteCellView *deleteView = [[GTDeleteCellView alloc] initWithFrame:self.view.bounds];
//    __weak typeof(self) weakSelf = self;
//    [deleteView showDeleteViewFromPoint:point
//                             clickBlock:^{
//        // 删除cell逻辑
//        __strong typeof(self) strongSelf = weakSelf;
//        // 确定要展示的cell个数
//        [strongSelf.dataArray removeLastObject];
//        [strongSelf.tableView deleteRowsAtIndexPaths:@[[strongSelf.tableView indexPathForCell:cell]]
//                                    withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//                       cellDeleteButton:deleteButton];
}

@end
