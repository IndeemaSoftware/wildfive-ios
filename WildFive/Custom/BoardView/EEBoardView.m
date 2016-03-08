//
//  EEBoardView.m
//  WildFive
//
//  Created by Volodymyr Shevchyk Jr on 3/6/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "EEBoardView.h"
#import "EEBoardViewItem.h"
#import "EEBoardCollectionViewLayoutFlow.h"

@interface EEBoardView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    EEBoardCollectionViewLayoutFlow *_collectionViewLayoutFlow;
}

- (UICollectionView*)collectionView;
- (EEBoardCollectionViewLayoutFlow*)collectionViewLayoutFlow;

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
//        [_collectionView setUserInteractionEnabled:NO];
        [_collectionView registerClass:[EEBoardViewItem class] forCellWithReuseIdentifier:[EEBoardViewItem reuseIdentifier]];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (EEBoardCollectionViewLayoutFlow*)collectionViewLayoutFlow {
    if (_collectionViewLayoutFlow == nil) {
        _collectionViewLayoutFlow = [[EEBoardCollectionViewLayoutFlow alloc] init];
        [_collectionViewLayoutFlow setScrollDirection:UICollectionViewScrollDirectionVertical];
        [_collectionViewLayoutFlow setItemSize:CGSizeMake(15.0f, 15.0f)];
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
    
    [lCell setTitle:[NSString stringWithFormat:@"%i%i", indexPath.item, indexPath.section]];
    
    return lCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate != nil) {
        [self.delegate boardView:self playerSetNewSignAtPoint:EEBoardPointMake(indexPath.item, indexPath.section)];
    }
}

@end
