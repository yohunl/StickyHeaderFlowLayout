//
//  CollectionViewCell.m
//  StickyHeaderFlowLayout
//
//  Created by lingyohunl on 16/1/25.
//  Copyright © 2016年 yohunl. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIView+Helpers.h"
@implementation CollectionViewCell
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
    _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:_imgView];
    
    _imgTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 14)];
    _imgTitleLabel.font = [UIFont systemFontOfSize:13];
    _imgTitleLabel.textColor = [UIColor whiteColor];
    _imgTitleLabel.textAlignment = NSTextAlignmentCenter;
    _imgTitleLabel.numberOfLines = 0;
    _imgTitleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_imgTitleLabel];
    
    _imgView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imgView.frame = self.bounds;
    _imgTitleLabel.frameSize = CGSizeMake(self.frameSizeWidth - 10, 14);
    [_imgTitleLabel bottomAlignForSuperViewOffset:5];
    _imgTitleLabel.hidden = !_imgTitleLabel.text;
    
}

@end
