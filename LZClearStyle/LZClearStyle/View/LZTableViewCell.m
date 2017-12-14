//
//  LZTableViewCell.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LZTableViewCell.h"

@interface LZTableViewCell() <UIGestureRecognizerDelegate, UITextFieldDelegate>

{
    LZStrikethroughLabel    *_label;                        // 内容
    UILabel                 *_tickLabel;                    // 完成提示
    UILabel                 *_crossLabel;                   // 删除提示
    CALayer                 *_itemCompleteLayer;
    CAGradientLayer         *_gradientLayer;
    CGPoint                 _originalCenter;                // 视图初始center
    BOOL                    _deleteOnDragRelease;           // 标记手势为删除
    BOOL                    _markCompleteOnDragRelease;     // 标记手势为完成状态
}

@end

@implementation LZTableViewCell

const float LABEL_LEFT_MARGIN = 15.0f;
const float UI_CUES_MARGIN = 15.0f;
const float UI_CUES_WIDTH = 50.0f;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        [self addRenderLayer];
        [self createSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
    _itemCompleteLayer.frame = self.bounds;
    _label.frame = CGRectMake(UI_CUES_MARGIN, 0, self.bounds.size.width - LABEL_LEFT_MARGIN, self.bounds.size.height);
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
    _crossLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
}

- (void)setTodoItem:(LZToDoItem *)todoItem {
    _todoItem = todoItem;
    _label.text = todoItem.text;
    _label.strikethrough = todoItem.completed;
    _itemCompleteLayer.hidden = !todoItem.completed;
}

- (void)createSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 创建label,显示待办项的文本
    _label = [[LZStrikethroughLabel alloc] initWithFrame:CGRectNull];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont boldSystemFontOfSize:16];
    _label.backgroundColor = [UIColor clearColor];
    _label.delegate = self;
    _label.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:_label];
    
    // add a tick and cross
    _tickLabel = [UILabel cueLabel];
    _tickLabel.text = @"\u2713";
    _tickLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_tickLabel];
    _crossLabel = [UILabel cueLabel];
    _crossLabel.text = @"\u2717";
    _crossLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_crossLabel];
}

- (void)addRenderLayer {
    // 添加初始layer
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.colors = @[
                              (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                              (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                              (id)[UIColor clearColor].CGColor,
                              (id)[UIColor colorWithWhite:0.0f alpha:0.1f].CGColor
                              ];
    _gradientLayer.locations = @[@0.00f,@0.01f,@0.95f,@1.00f];
    [self.layer insertSublayer:_gradientLayer atIndex:0];

    // 任务完成时添加一个成功的layer
    _itemCompleteLayer = [CALayer layer];
    _itemCompleteLayer.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
    _itemCompleteLayer.hidden = YES;
    [self.layer insertSublayer:_itemCompleteLayer atIndex:0];
}

- (LZStrikethroughLabel *)label {
    return _label;
}

#pragma mark - UIPanGestureRecognizer handlers
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    if (fabs(translation.x) > fabs(translation.y)) {
        return YES;
    }
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 手势开始
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _originalCenter = self.center;
    }
    
    // 手势ing
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _deleteOnDragRelease = self.frame.origin.x < - self.frame.size.width / 2;
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        
        CGFloat cueAlpha = fabs(self.frame.origin.x) / (self.frame.size.width);
        _tickLabel.alpha = cueAlpha;
        _crossLabel.alpha = cueAlpha;
    
        _tickLabel.textColor = _markCompleteOnDragRelease ? [UIColor greenColor] : [UIColor whiteColor];
        _crossLabel.textColor = _deleteOnDragRelease ? [UIColor redColor] : [UIColor whiteColor];
    }
    
    // 手势结束
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        
        // 删除
        if (!_deleteOnDragRelease) {
            [UIView animateWithDuration:0.2f animations:^{
                self.frame = originalFrame;
            }];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(toDoItemDeleted:)]) {
                [self.delegate toDoItemDeleted:self.todoItem];
            }
        }
        
        // 完成
        if (_markCompleteOnDragRelease) {
            self.todoItem.completed = YES;
            _label.strikethrough = self.todoItem.completed;
            _itemCompleteLayer.hidden = !self.todoItem.completed;
        }
    }
}

#pragma mark - UITextFieldDelegate handlers
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 按下enter关闭键盘
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 如果任务没有完成才能被编辑
    return !self.todoItem.completed;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidBeginEditing:)]) {
        [self.delegate cellDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidEndEditing:)]) {
        [self.delegate cellDidEndEditing:self];
    }
    self.todoItem.text = textField.text;
}

@end

@implementation UILabel (LZLabel)

+ (UILabel *)cueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

@end
