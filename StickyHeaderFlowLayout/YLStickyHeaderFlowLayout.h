//
//  YLStickyHeaderFlowLayout.h
//  StickyHeaderFlowLayout
//
//  Created by lingyohunl on 16/1/25.
//  Copyright © 2016年 yohunl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLStickyHeaderFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign)BOOL disableStickyFlow;

/**
 *  固定header的section数组.如果不为空,则会自动设置disableStickyFlow 的值
 */
@property (nonatomic,strong) NSArray<NSNumber *> *stickySections;
@end
