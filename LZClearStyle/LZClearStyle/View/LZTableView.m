//
//  LZTableView.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/13.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZTableView.h"

@implementation LZTableView

{
    UIScrollView *_scrollView;
    NSMutableSet *_reuseCells;
    Class         _cellClass;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self prepare];
        [self addContentView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self refreshView];
}

#pragma mark - initiz
- (void)prepare {
    _reuseCells = [NSMutableSet new];
}

- (void)addContentView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

- (void)refreshView {
    // 如果没实现数据源代理直接抛出
    NSAssert(self.dataSource, @"请实现tableView的数据源代理方法");

    // _scrollView没有frame直接返回
    if (CGRectIsNull(_scrollView.frame)) return;
    
    // 设置scroll的滑动区域
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, [_dataSource numberOfRows] * LZ_ROW_HEIGHT);
    
    for (UIView *cell in [self cellSubViews]) {
        if (cell.frame.origin.y + cell.frame.size.height < _scrollView.contentOffset.y) {
            [self recycleCell:cell];
        }
        
        if (cell.frame.origin.y > _scrollView.contentOffset.y + _scrollView.frame.size.height) {
            [self recycleCell:cell];
        }
    }
    
    int firstVisibleIndex = MAX(0, floor(_scrollView.contentOffset.y / LZ_ROW_HEIGHT));
    int lastVisibleIndex = MIN([_dataSource numberOfRows], firstVisibleIndex + 1 + ceil(_scrollView.frame.size.height / LZ_ROW_HEIGHT));
    
    // 添加cell
    for (int row = firstVisibleIndex; row < lastVisibleIndex; row ++) {
        UIView *cell = [self cellForRow:row];
        if (!cell) {
            UIView *cell = [_dataSource tableView:self cellForRow:row];
            CGFloat topEdgeForRow = row * LZ_ROW_HEIGHT;
            cell.frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, LZ_ROW_HEIGHT);
            [_scrollView insertSubview:cell atIndex:0];
        }
        
    }
}

- (void)recycleCell:(UIView *)cell {
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}

- (UIView *)cellForRow:(NSUInteger)row {
    CGFloat topEdgeForRow = row * LZ_ROW_HEIGHT;
    for (UIView *cell in [self cellSubViews]) {
        if (cell.frame.origin.y >= topEdgeForRow && cell.frame.origin.y < topEdgeForRow + LZ_ROW_HEIGHT) {
            return cell;
        }
    }
    return nil;
}

- (NSArray *)cellSubViews {
    NSMutableArray *cells = [NSMutableArray new];
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[UITableViewCell class]]) {
            [cells addObject:subView];
        }
    }
    return cells;
}

- (void)setDataSource:(id<LZTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

#pragma mark - Public
- (UIView *)dequeueReusableCell {
    UIView *cell = [_reuseCells anyObject];
    if (cell) {
        [_reuseCells removeObject:cell];
    }
    if (!cell) {
        cell = [_cellClass new];
    }
    return cell;
}

- (void)registerClassForCellReuse:(Class)cellClass {
    _cellClass = cellClass;
}

- (NSArray *)visibleCells {
    NSMutableArray *cells = [NSMutableArray new];
    for (UIView *cell in [self cellSubViews]) {
        [cells addObject:cell];
    }
    
    NSArray *sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView *view1 = (UIView *)obj1;
        UIView *view2 = (UIView *)obj2;
        CGFloat result =view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.0) {
            return NSOrderedAscending;
        } else if (result < 0.0) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedCells;
}

- (void)reloadData {
    // 移除所有cell
    [[self cellSubViews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

#pragma mark - UIScrollViewDelegate handlers
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate forwarding
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
