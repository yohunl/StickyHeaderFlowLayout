//
//  ViewController.m
//  StickyHeaderFlowLayout
//
//  Created by lingyohunl on 16/1/25.
//  Copyright © 2016年 yohunl. All rights reserved.
//

#import "ViewController.h"
#import "SectionHeaderReusableView.h"
#import "YLStickyHeaderFlowLayout.h"
#import "CollectionViewCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadLayout];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    [self.collectionView registerClass:[SectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"HeadIdentifier"];
    [self.collectionView registerClass:[SectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"FootIdentifier"];
    
}
- (void)reloadLayout {
    YLStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[YLStickyHeaderFlowLayout class]]) {
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 5)/2, 100);
        //layout.itemSize = CGSizeMake(self.view.frame.size.width / 3.0, 44);
        //layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //layout.minimumLineSpacing = 5;
        //layout.minimumInteritemSpacing = 5;
        layout.disableStickyFlow = NO;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    cell.imgView.backgroundColor = indexPath.section%2?[UIColor redColor]:[UIColor cyanColor];
    cell.imgTitleLabel.text = [NSString stringWithFormat:@"%ld,%ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind==UICollectionElementKindSectionFooter) {
        SectionHeaderReusableView *footer = [collectionView  dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FootIdentifier" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor colorWithRed:0.4016 green:0.4015 blue:0.0 alpha:1.0];
        footer.textLabel.text = [NSString stringWithFormat:@"第%ld个分区的footer",indexPath.section];
        return footer;
    }
    
    if (indexPath.section >0) {
        SectionHeaderReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadIdentifier" forIndexPath:indexPath];
        header.backgroundColor = indexPath.section%2?[[UIColor blackColor] colorWithAlphaComponent:0.5] : [[UIColor blueColor] colorWithAlphaComponent:0.5];
        header.textLabel.text = [NSString stringWithFormat:@"第%ld个分区的header",indexPath.section];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section>0) {
        return CGSizeMake(0, 44);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section==3) {
        return CGSizeZero;
    }
    return CGSizeMake(0, 20);
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
