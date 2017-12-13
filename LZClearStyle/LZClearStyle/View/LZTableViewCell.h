//
//  LZTableViewCell.h
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZToDoItem.h"

@class LZTableViewCell;

@protocol LZTableViewCellDelegate <NSObject>

@optional

- (void)toDoItemDeleted:(LZToDoItem *)todoItem;

- (void)cellDidBeginEditing:(LZTableViewCell *)editingCell;

- (void)cellDidEndEditing:(LZTableViewCell *)editingCell;

@end

@interface LZTableViewCell : UITableViewCell

@property (nonatomic) LZToDoItem *todoItem;

@property (nonatomic, assign) id <LZTableViewCellDelegate> delegate;


@end


@interface UILabel(LZLabel)

+ (UILabel *)cueLabel;

@end
