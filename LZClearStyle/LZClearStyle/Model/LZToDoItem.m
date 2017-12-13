//
//  LZToDoItem.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZToDoItem.h"

@implementation LZToDoItem

- (instancetype)initWithText:(NSString *)text {
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

+ (instancetype)toDoItemWithText:(NSString *)text {
    return [[LZToDoItem alloc] initWithText:text];
}

@end
