//
//  LZTableViewPinchToAdd.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/14.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZTableViewPinchToAdd.h"
#import "LZTableViewCell.h"

@implementation LZTableViewPinchToAdd

{
    LZTableView         *_tableView;
    LZTableViewCell     *_placeholderCell;
}

- (instancetype)initWithTableView:(LZTableView *)tableView {
    self = [super init];
    if (self) {
        _placeholderCell = [LZTableViewCell new];
        _placeholderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        
        // 添加捏合手势
        UIGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [_tableView addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
}

@end
