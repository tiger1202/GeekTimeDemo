//
//  GTListLoader.m
//  Demo
//
//  Created by tiger on 2022/6/1.
//

#import "GTListLoader.h"
#import <AFNetworking.h>
#import "GTListItem.h"

@implementation GTListLoader

#pragma mark - 文件夹路径
- (NSString *)cachePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [pathArray firstObject]; // sandbox_cache文件夹路径
    return cachePath;
}

- (NSString *)dataPath {
    NSString *dataPath = [[self cachePath] stringByAppendingPathComponent:@"GTData"]; // 数据文件夹路径
    return dataPath;
}

- (NSString *)listDataPath {
    NSString *listDataPath = [[self dataPath] stringByAppendingPathComponent:@"list"];
    return listDataPath;
}

#pragma mark - 存取列表数据

// 私有方法名前缀_
- (NSArray<GTListItem *> *)_readDataFromLocal {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *readListData = [fileManager contentsAtPath:[self listDataPath]];
    id unarchiveObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [GTListItem class], nil] fromData:readListData error:nil];
    if ([unarchiveObj isKindOfClass:[NSArray class]] && [unarchiveObj count] > 0) {
        return (NSArray<GTListItem *> *)unarchiveObj; // 强转的意义？
    }
    return nil;
}

- (void)loadListDataWithFinishBlock:(GTListLoaderFinishBlock)finishBlock {
    NSArray<GTListItem *> *listData = [self _readDataFromLocal];
    if (listData) {
        finishBlock(YES, listData);
    }
    
    NSString *urlString = @"http://v.juhe.cn/toutiao/index?type=top&key=97ad001bfcc2082e2eeaf798bad3d54e";
    NSURL *listURL = [NSURL URLWithString:urlString];

//    NSURLRequest *listRequest = [NSURLRequest requestWithURL:listURL];

    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *dataTask = [session dataTaskWithURL:listURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSError *jsonError;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (![jsonObj isKindOfClass:[NSDictionary class]]) {
            return ; // jsonObj类型检查
        }
        if (![[jsonObj objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@, don't reload data", [jsonObj objectForKey:@"reason"]); // 输出result出错的reason
            return ; // result类型检查
        }
        NSDictionary *result = [jsonObj objectForKey:@"result"];
        if (![[result objectForKey:@"data"] isKindOfClass:[NSArray class]] || [[result objectForKey:@"data"] count] == 0) {
            return ; // dataArray类型检查
        }
        NSArray *dataArray = [result objectForKey:@"data"];
        NSMutableArray *listItemArray = @[].mutableCopy;
        for (NSDictionary *info in dataArray) {
            GTListItem *item = [GTListItem new];
            [item configWithDictionary:info];
            [listItemArray addObject:item];
        }
        [strongSelf _archiveListDataWithArray:listItemArray.copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishBlock) {
                finishBlock(error == nil, listItemArray.copy);
            }
        });
    }];
    [dataTask resume];
}

- (void)_archiveListDataWithArray:(NSArray<GTListItem *> *)array {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 创建列表数据文件夹
    NSError *createError;
    [fileManager createDirectoryAtPath:[self dataPath] withIntermediateDirectories:YES attributes:nil error:&createError];
    
    // 序列化列表数据并创建文件
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:nil];
    [fileManager createFileAtPath:[self listDataPath] contents:listData attributes:nil];
    
    // 反序列化列表数据
    NSData *readListData = [fileManager contentsAtPath:[self listDataPath]];
    id unarchiveObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [GTListItem class], nil] fromData:readListData error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:listData forKey:@"listData"];
    NSData *testListData = [[NSUserDefaults standardUserDefaults] objectForKey:@"listData"];
    
// 查询文件
//    BOOL fileExist = [fileManager fileExistsAtPath:listDataPath];
    
// 删除文件
//    NSError *removeError;
//    if (fileExist) {
//        [fileManager removeItemAtPath:listDataPath error:&removeError];
//    }
    
// fileHandle处理单个文件
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:listDataPath];
//    [fileHandle seekToEndOfFile];
//    [fileHandle writeData:[@"def" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    [fileHandle synchronizeFile]; // 刷新缓存，文件同步到磁盘
//    [fileHandle closeFile]; // 关闭文件
}

@end
