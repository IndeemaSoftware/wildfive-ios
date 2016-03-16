//
//  EEWallpaperCollectionViewFlowLayout.m
//  HD Wallpaper 8
//
//  Created by Admin on 4/17/15.
//  Copyright (c) 2015 Indeema. All rights reserved.
//

#import "EEBoardCollectionViewLayoutFlow.h"

@interface EEBoardCollectionViewLayoutFlow() {
    CGSize _contentSize;
}

@end

@implementation EEBoardCollectionViewLayoutFlow

- (instancetype)init {
    self = [super init];
    if (self) {
        self.footerReferenceSize = CGSizeZero;
        self.headerReferenceSize = CGSizeZero;
        
        self.minimumInteritemSpacing = 0.0f;
        self.minimumLineSpacing = 0.0f;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.footerReferenceSize = CGSizeZero;
    self.headerReferenceSize = CGSizeZero;
}

- (void)prepareLayout {
    
    
    NSUInteger lHieght = [self.collectionView numberOfSections];
    NSUInteger lWidth = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat lCellSize = floorf(self.collectionView.frame.size.width / lWidth);
    
    _contentSize = CGSizeMake(lCellSize * lWidth, lCellSize * lHieght);
    
    CGFloat lFreeSpace = self.collectionView.frame.size.width - _contentSize.width;
    CGFloat lOffset = lFreeSpace / 2.0f;
    
    self.sectionInset = UIEdgeInsetsMake(lOffset, lOffset, lOffset, lOffset);
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize canvasSize = self.collectionView.frame.size;
    CGSize contentSize = self.collectionViewContentSize;
//
//    NSUInteger rowCount = 1;
//    NSUInteger columnCount = 1;
//    
//    CGFloat pageMarginY = (canvasSize.height - rowCount * self.itemSize.height - (rowCount > 1 ? (rowCount - 1) : 0));
//    
//    NSUInteger page = indexPath.row / (rowCount * columnCount);
//    NSUInteger remainder = indexPath.row - page * (rowCount * columnCount);
//    NSUInteger row = remainder / columnCount;
//    
//    CGRect cellFrame = CGRectZero;
//    cellFrame.origin.x = 0 ;
//    cellFrame.origin.y = pageMarginY + row;
//    cellFrame.size.width = self.itemSize.width;
//    cellFrame.size.height = self.itemSize.height;
    
//    NSLog(@"indexPath %@", indexPath);
    
    CGRect cellFrame = CGRectZero;
    cellFrame.origin.x = indexPath.item * self.itemSize.width;
    cellFrame.origin.y = indexPath.section * self.itemSize.height;
    cellFrame.size.width = self.itemSize.width;
    cellFrame.size.height = self.itemSize.height;
    
    return cellFrame;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    attr.frame = [self frameForItemAtIndexPath:indexPath];
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray * originAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * attrs = [NSMutableArray array];
    
    [originAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * attr, NSUInteger idx, BOOL *stop) {
        NSIndexPath * idxPath = attr.indexPath;
        CGRect itemFrame = [self frameForItemAtIndexPath:idxPath];
        if (CGRectIntersectsRect(itemFrame, rect)) {
            attr = [self layoutAttributesForItemAtIndexPath:idxPath];
            [attrs addObject:attr];
        }
    }];
    
    return attrs;
}
@end
