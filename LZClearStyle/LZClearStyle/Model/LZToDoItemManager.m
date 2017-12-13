//
//  LZToDoItemManager.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZToDoItemManager.h"
//#import <LZArchiver/LZArchiver.h>

static NSString *const kFileName = @"todoItems";

@interface LZToDoItemManager()

{
    NSMutableArray *_toDoItems;
}

@end

@implementation LZToDoItemManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // Add task
        _toDoItems = [NSMutableArray new];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Feed the cat"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Buy eggs"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Pack bags for WWDC"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Rule the web"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Buy a new iPhone"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Find missing socks"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Write a new tutorial"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Master Objective-C"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Remember your wedding anniversary!"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Drink less beer"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Learn to draw"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Take the car to the garage"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Sell things on eBay"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Learn to juggle"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Give up"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Give up"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Give up"]];
        [_toDoItems addObject:[LZToDoItem toDoItemWithText:@"Give up"]];
    }
    return self;
}

- (NSArray *)getToDoItems {
    return _toDoItems;
}

- (void)addToDoItem:(LZToDoItem *)item atIndex:(NSInteger)index {
    if (_toDoItems.count > index) {
        [_toDoItems insertObject:item atIndex:index];
    } else {
        [_toDoItems addObject:item];
    }
}

- (void)deleteToDoItemAtIndex:(NSInteger)index {
    if (index < _toDoItems.count) {
        [_toDoItems removeObjectAtIndex:index];
    } else {}
}

- (void)deleteToDoItem:(LZToDoItem *)item {
    [_toDoItems removeObject:item];
}

@end
