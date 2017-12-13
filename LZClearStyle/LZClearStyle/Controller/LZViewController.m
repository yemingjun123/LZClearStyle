//
//  LZViewController.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZViewController.h"
#import "LZToDoItemManager.h"
#import "LZTableViewCell.h"

@interface LZViewController ()<LZTableViewDataSource, LZTableViewCellDelegate>

{
    LZToDoItemManager   *_manager;
    NSArray             *_toDoItems;
    CGFloat              _editingOffset;
}

@end

@implementation LZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _manager = [LZToDoItemManager new];
    
    [self loadData];
    [self setupTableView];
}


- (void)loadData {
    _toDoItems = [_manager getToDoItems];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    [self.tableView registerClassForCellReuse:[LZTableViewCell class]];
}

- (UIColor *)colorForIndex:(NSInteger)index {
    NSUInteger itemCount = _toDoItems.count - 1;
    float val = ((float)index / (float)itemCount) * 0.6;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - LZTableViewDataSource handlers
- (NSInteger)numberOfRows {
    return _toDoItems.count;
}

- (UIView *)tableView:(LZTableView *)tableView cellForRow:(NSInteger)row {
    LZTableViewCell *cell = (LZTableViewCell *)[tableView dequeueReusableCell];
    LZToDoItem *item = _toDoItems[row];
    cell.todoItem = item;
    cell.delegate = self;
    cell.backgroundColor = [self colorForIndex:row];
    return cell;
}

#pragma mark - LZTableViewCellDelegate handlers
- (void)toDoItemDeleted:(LZToDoItem *)todoItem {
    CGFloat delay = 0.0f;
    // 删除数据
    [_manager deleteToDoItem:todoItem];
    
    // 拿到可视范围的cell
    NSArray *visibleCells = [_tableView visibleCells];
    
    UIView *lastView = [visibleCells lastObject];
    BOOL startAnimating = false;
    
    for (LZTableViewCell *cell in visibleCells) {
        if (startAnimating) {
            [UIView animateWithDuration:0.3f delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.frame = CGRectOffset(cell.frame, 0.0f, - cell.frame.size.height);
            } completion:^(BOOL finished) {
                if (cell == lastView) {
                    [self.tableView reloadData];
                }
            }];
            delay += 0.03f;
        }
        // 如果遍历到被删除的项目,开始动画
        if (cell.todoItem == todoItem) {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
}

- (void)cellDidBeginEditing:(LZTableViewCell *)editingCell {
    _tableView.scrollView.scrollEnabled = NO;
    _editingOffset = _tableView.scrollView.contentOffset.y - editingCell.frame.origin.y;
    for (LZTableViewCell *cell in [_tableView visibleCells]) {
        [UIView animateWithDuration:0.3f animations:^{
            cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
            if (cell != editingCell) {
                cell.alpha = 0.3f;
                cell.userInteractionEnabled = NO;
            }
        }];
    }
}

- (void)cellDidEndEditing:(LZTableViewCell *)editingCell {
    _tableView.scrollView.scrollEnabled = YES;
    for (LZTableViewCell *cell in [_tableView visibleCells])  {
        [UIView animateWithDuration:0.3f animations:^{
            cell.frame = CGRectOffset(cell.frame, 0, -_editingOffset);
            if (cell != editingCell) {
                cell.alpha = 1.0f;
                cell.userInteractionEnabled = YES;
            }
        }];
    }
}


/*
#pragma mark - UITableViewDataSource protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _toDoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LZToDoItem *item = _toDoItems[indexPath.row];
    cell.todoItem = item;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
}
 
#pragma mark - LZTableViewCellDelegate protocol method
- (void)toDoItemDeleted:(LZToDoItem *)todoItem {
    CGFloat delay = 0.0f;
    
    // 删除数据
    [_manager deleteToDoItem:todoItem];
    
    // 拿到可视范围的cell
    NSArray *visibleCells = [_tableView visibleCells];
    
    UIView *lastView = [visibleCells lastObject];
    BOOL startAnimating = false;
    
    for (LZTableViewCell *cell in visibleCells) {
        if (startAnimating) {
            [UIView animateWithDuration:0.3f delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
                cell.frame = CGRectOffset(cell.frame, 0.0f, - cell.frame.size.height);
            } completion:^(BOOL finished) {
                if (cell == lastView) {
                    [self.tableView reloadData];
                }
            }];
            delay += 0.03f;
        }
        
        // 如果遍历到被删除的项目,开始动画
        if (cell.todoItem == todoItem) {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
}
*/

@end

