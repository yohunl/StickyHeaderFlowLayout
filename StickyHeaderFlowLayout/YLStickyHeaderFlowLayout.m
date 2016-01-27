//
//  YLStickyHeaderFlowLayout.m
//  StickyHeaderFlowLayout
//
//  Created by lingyohunl on 16/1/25.
//  Copyright © 2016年 yohunl. All rights reserved.
//

#import "YLStickyHeaderFlowLayout.h"

@implementation YLStickyHeaderFlowLayout
#pragma mark - 设置方法

- (void)setStickySections:(NSArray<NSNumber *> *)stickySections {
    _stickySections = stickySections;
    _disableStickyFlow = (_stickySections.count > 0)?NO:YES;
}
#pragma mark - 重载方法
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    if (self.disableStickyFlow) {
        return [super shouldInvalidateLayoutForBoundsChange:newBound];
    }
    /*每滑动一点,就会调用这个,然后layoutAttributesForElementsInRect又被调用,其实有点浪费了,但是我们又没有好的方式避免,毕竟,如果要悬浮,就要每时每刻计算是否应该悬浮
     一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
     实际上我们很多自定义的layout,都是要根据实际需要,返回YES或者NO的
     
     当collection view的bounds改变时，布局需要告诉collection view是否需要重新计算布局。我的猜想是：当collection view改变大小时，大多数布局会被作废，比如设备旋转的时候。因此，一个幼稚的实现可能只会简单的返回YES。虽然实现功能很重要，但是scroll view的bounds在滚动时也会改变，这意味着你的布局每秒会被丢弃多次。根据计算的复杂性判断，这将会对性能产生很大的影响。
     
     当collection view的宽度改变时，我们自定义的布局必须被丢弃，但这滚动并不会影响到布局。幸运的是，collection view将它的新bounds传给shouldInvalidateLayoutForBoundsChange: method。这样我们便能比较视图当前的bounds和新的bounds来确定返回值：
     
     
     - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
     // not sure about his..
     if ((self.collectionView.bounds.size.width != newBounds.size.width) || (self.collectionView.bounds.size.height != newBounds.size.height)) {
     return YES;
     }
     return NO;
     }
     其子类flowLayout的
     - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
     // we need to recalculate on width changes
     if ((_visibleBounds.size.width != newBounds.size.width && self.scrollDirection == PSTCollectionViewScrollDirectionVertical) || (_visibleBounds.size.height != newBounds.size.height && self.scrollDirection == PSTCollectionViewScrollDirectionHorizontal)) {
     _visibleBounds = self.collectionView.bounds;
     return YES;
     }
     return NO;
     }
     */
    return YES;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.disableStickyFlow) {
        return [super layoutAttributesForElementsInRect:rect];
    }
    NSMutableArray<UICollectionViewLayoutAttributes *> *allItems ;
    //collectionView中的item（包括cell和header、footer这些）的《结构信息》.关键!!!!cell,header,footer都是利用这个数组的,在这个中,原来创建的section等,要按顺序存放到数组中来!
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    //allItems = (NSMutableArray *)originalAttributes ;
    allItems = [originalAttributes mutableCopy];//实际上layoutAttributesForElementsInRect返回的是NSMutableArray,所以,可以直接强转
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];//存放每个section的header
    NSMutableDictionary<NSNumber *,UICollectionViewLayoutAttributes *> *lastCells = [[NSMutableDictionary alloc] init];//存放的是每个section的最后一个cell
    [allItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSIndexPath *indexPath = [obj indexPath];
        BOOL isHeader = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader];
        BOOL isFooter = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter];
        
        if (isHeader) {
            headers[@(indexPath.section)] = obj;
        } else if (isFooter) {
            // 不处理
        } else {
            //其实用这两句也是可以的
            //NSNumber *sectionObj = @(indexPath.section);
            //lastCells[sectionObj] = obj;
            
            UICollectionViewLayoutAttributes *currentAttribute = lastCells[@(indexPath.section)];
            // 确保取到的是section中最后一个cell
            if ( ! currentAttribute || indexPath.row > currentAttribute.indexPath.row) {
                [lastCells setObject:obj forKey:@(indexPath.section)];
            }
        }
        
        //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
        //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个1024
        if (isHeader) {
            obj.zIndex = 1024;
        } else {
            // For iOS 7.0, the cell zIndex should be above sticky section header
            obj.zIndex = 1;
        }
        
    }];
    
    
    [lastCells enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UICollectionViewLayoutAttributes * _Nonnull obj, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = obj.indexPath;
        NSNumber *indexPathKey = @(indexPath.section);
        
        UICollectionViewLayoutAttributes *header = headers[indexPathKey];
        
        if ( ! header) {
            // CollectionView自动将不再bounds内的headers移除了,所以,Headers可能为nil.这种情况下我们需要重新将其加回来 automatically removes headers not in bounds
            header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
            
            if (!CGSizeEqualToSize(CGSizeZero, header.frame.size)) {
                if ([self haveSection:indexPath.section]) {
                    [allItems addObject:header];
                }
                
                
            }
        }
        if (!CGSizeEqualToSize(CGSizeZero, header.frame.size)) {
            
            if ([self haveSection:indexPath.section]) {
                [self updateHeaderAttributes:header lastCellAttributes:lastCells[indexPathKey]];
            }
            
            
        }
    }];
    
    
    return allItems;
    
}


#pragma mark - 辅助方法
- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes
{
    //lastCellAttributes是section中最后一个cell的attribute
    CGRect currentBounds = self.collectionView.bounds;
    
    CGPoint origin = attributes.frame.origin;
    
    //sectionMaxY是header的originY最大可达到的地方
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - CGRectGetHeight(attributes.frame);
    CGFloat y = CGRectGetMinY(currentBounds) + self.collectionView.contentInset.top;
    
    
    CGFloat originY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    
    origin.y = originY;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}



- (BOOL)haveSection:(NSInteger )section {
    __block BOOL flag = NO;
    if (_stickySections.count == 0) {//为空表示所有的header都是要悬停的
        flag = YES;
    }
    else {
        [_stickySections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.integerValue == section) {
                flag = YES;
                *stop = YES;
            }
        }];
    }
    
    return flag;
}
@end
