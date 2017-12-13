//
//  LZToDoItemManager.h
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZToDoItem.h"


@interface LZToDoItemManager : NSObject


- (NSArray *)getToDoItems;

- (void)addToDoItem:(LZToDoItem *)item atIndex:(NSInteger)index;

- (void)deleteToDoItemAtIndex:(NSInteger)index;

- (void)deleteToDoItem:(LZToDoItem *)item;


@end
