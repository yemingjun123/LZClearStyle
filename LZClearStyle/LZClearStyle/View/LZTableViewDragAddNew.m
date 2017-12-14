//
//  LZTableViewDragAddNew.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/14.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZTableViewDragAddNew.h"
#import "LZTableViewCell.h"

@implementation LZTableViewDragAddNew

{
    LZTableView     *_tableView;
    LZTableViewCell *_placeholderCell;
    BOOL             _pullDownInProgress;
}


- (instancetype)initWithTableView:(LZTableView *)tableView {
    self = [super init];
    if (self) {
        _placeholderCell = [LZTableViewCell new];
        _placeholderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        _tableView.delegate = self;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if (_pullDownInProgress) {
        [_tableView insertSubview:_placeholderCell atIndex:0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pullDownInProgress && _tableView.scrollView.contentOffset.y <= 0.0f) {
        _placeholderCell.frame = CGRectMake(0, -_tableView.scrollView.contentOffset.y - LZ_ROW_HEIGHT, _tableView.scrollView.frame.size.width, LZ_ROW_HEIGHT);
        _placeholderCell.label.text = -_tableView.scrollView.contentOffset.y > LZ_ROW_HEIGHT ? @"发布到添加任务" : @"下拉添加项目";
    } else {
        _pullDownInProgress = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_pullDownInProgress && - _tableView.scrollView.contentOffset.y > LZ_ROW_HEIGHT) {
        if (_tableView.dataSource && [_tableView.dataSource respondsToSelector:@selector(itemAdded)]) {
            [_tableView.dataSource itemAdded];
        }
    }
    _pullDownInProgress = NO;
    [_placeholderCell removeFromSuperview];
}

@end
