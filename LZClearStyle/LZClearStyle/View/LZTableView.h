//
//  LZTableView.h
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/13.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LZ_ROW_HEIGHT 50.0f

@class LZTableView;

@protocol LZTableViewDataSource <NSObject>

@required

- (NSInteger)numberOfRows;

- (UIView *)tableView:(LZTableView *)tableView cellForRow:(NSInteger)row;

- (void)itemAdded;

@end


@interface LZTableView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id<LZTableViewDataSource> dataSource;

@property (nonatomic, assign) id<UIScrollViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// 从复用池获取可复用的cell,如果没有可复用的就创建一个新的cell
- (UIView *)dequeueReusableCell;

// 通过Class注册可复用的cell
- (void)registerClassForCellReuse:(Class)cellClass;

// 返回当前可视范围里的cell
- (NSArray *)visibleCells ;

//  刷新数据源
- (void)reloadData;

@end
