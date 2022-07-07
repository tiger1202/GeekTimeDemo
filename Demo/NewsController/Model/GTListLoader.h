//
//  GTListLoader.h
//  Demo
//
//  Created by tiger on 2022/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GTListItem;
typedef void(^GTListLoaderFinishBlock)(BOOL success, NSArray<GTListItem *> *dataArray);

/**
 列表请求
 */

@interface GTListLoader : NSObject

- (void)loadListDataWithFinishBlock:(GTListLoaderFinishBlock)finishBlock;

@end

NS_ASSUME_NONNULL_END
