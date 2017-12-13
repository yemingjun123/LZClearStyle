//
//  LZStrikethroughLabel.m
//  LZClearStyle
//
//  Created by 叶明君 on 2017/12/11.
//  Copyright © 2017年 叶明君. All rights reserved.
//

#import "LZStrikethroughLabel.h"

@implementation LZStrikethroughLabel

{
    BOOL         _strikethrough;
    CALayer     *_strikethroughLayer;
}

const float STRIKEOUT_THICKNESS = 2.0f;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _strikethroughLayer = [CALayer layer];
        _strikethroughLayer.backgroundColor = [UIColor redColor].CGColor;
        _strikethroughLayer.hidden = YES;
        [self.layer addSublayer:_strikethroughLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self resizeStrikeThrough];
}

- (void)resizeStrikeThrough {
    NSDictionary *attrs = @{NSFontAttributeName : self.font};
    CGSize textSize = [self.text sizeWithAttributes:attrs];
    _strikethroughLayer.frame = CGRectMake(0, self.bounds.size.height / 2, textSize.width, STRIKEOUT_THICKNESS);
}

- (void)setStrikethrough:(BOOL)strikethrough {
    _strikethrough = strikethrough;
    _strikethroughLayer.hidden = !strikethrough;
}


@end
