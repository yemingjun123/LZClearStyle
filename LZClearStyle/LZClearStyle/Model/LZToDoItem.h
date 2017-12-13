//
//  LZToDoItem.h
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZToDoItem : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL completed;


- (instancetype)initWithText:(NSString *)text;

+ (instancetype)toDoItemWithText:(NSString *)text;

@end
