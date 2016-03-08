//
//  EEBoardView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoardView.h"
#import "EEBoardViewItem.h"



@interface EEBoardView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_collectionViewLayoutFlow;
}

- (UICollectionView*)collectionView;
- (UICollectionViewFlowLayout*)collectionViewLayoutFlow;

@end

@implementation EEBoardView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView setFrame:self.bounds];
}

#pragma mark - Public methods
- (void)reloadData {
    if (self.delegate == nil) {
        _boardSize = EEBoardSizeMake(3, 3);
    }
    
    _boardSize = [self.delegate boardSizeBoardView:self];
    
    [self.collectionView reloadData];
}

- (void)reloadDataAtPoint:(EEBoardPoint)point {
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:point.x inSection:point.y]]];
}

#pragma mark - Private methods
- (UICollectionView*)collectionView {
    if (_collectionView == nil) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayoutFlow];
        [_collectionView setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.3]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        [_collectionView setScrollEnabled:NO];
        [_collectionView setUserInteractionEnabled:NO];
        [_collectionView registerClass:[EEBoardViewItem class] forCellWithReuseIdentifier:[EEBoardViewItem reuseIdentifier]];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout*)collectionViewLayoutFlow {
    if (_collectionViewLayoutFlow == nil) {
        _collectionViewLayoutFlow = [[UICollectionViewFlowLayout alloc] init];
        [_collectionViewLayoutFlow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_collectionViewLayoutFlow setItemSize:CGSizeMake(30.0f, 30.0f)];
    }
    return _collectionViewLayoutFlow;
}

#pragma mark - UICollectionView delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _boardSize.height;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _boardSize.width;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EEBoardViewItem *lCell = [collectionView dequeueReusableCellWithReuseIdentifier:[EEBoardViewItem reuseIdentifier] forIndexPath:indexPath];
    
    if (self.delegate != nil) {
        [lCell setBoardSign:[self.delegate boardView:self boardSignAtPoint:EEBoardPointMake(indexPath.item, indexPath.section)]];
    } else {
        [lCell setBoardSign:EEBoardSignNone];
    }
    
    return lCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width / _boardSize.width, self.frame.size.height / _boardSize.height);
}

@end
