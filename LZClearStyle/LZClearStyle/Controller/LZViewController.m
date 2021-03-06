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
#import "LZTableViewDragAddNew.h"

@interface LZViewController ()<LZTableViewDataSource, LZTableViewCellDelegate>

{
    LZToDoItemManager       *_manager;
    LZTableViewDragAddNew   *_dragAddNew;
    NSArray                 *_toDoItems;
    CGFloat                  _editingOffset;
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
    _dragAddNew = [[LZTableViewDragAddNew alloc] initWithTableView:self.tableView];
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

- (void)itemAdded {
    LZToDoItem *toDoItem = [LZToDoItem new];
    [_manager addToDoItem:toDoItem atIndex:0];
    [self loadData];
    [_tableView reloadData];
    
    LZTableViewCell *editCell;
    for (LZTableViewCell *cell in [_tableView visibleCells]) {
        if (cell.todoItem == toDoItem) {
            editCell = cell;
            break;
        }
    }
    [editCell.label becomeFirstResponder];
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


@end

