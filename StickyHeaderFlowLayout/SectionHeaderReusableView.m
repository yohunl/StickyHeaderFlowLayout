//
//  SectionHeaderReusableView.m
//  XLPlainFlowLayoutDemo
//
//  Created by lingyohunl on 16/1/25.

//  Copyright © 2016年 yohunl. All rights reserved.

#import "SectionHeaderReusableView.h"

@implementation SectionHeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        
    }
    return self;
}

- (void)initialization
{
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 14)];
    _textLabel.font = [UIFont systemFontOfSize:13];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_textLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
    
}

@end
