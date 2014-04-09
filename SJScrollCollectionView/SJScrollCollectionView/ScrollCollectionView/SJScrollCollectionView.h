//
//  SJScrollCollectionView.h
//  SJScrollCollectionView
//
//  Created by SeokJong Gwak on 2014. 4. 3..
//  Copyright (c) 2014년 SeokJong Gwak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJScrollCollectionViewDelegate <NSObject>
@optional
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightColAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didHighlightColAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightColAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectColAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectColAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectColAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didDeselectColAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forColAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForColAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forColAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forColAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;

@end

@protocol SJScrollCollectionViewDataSource <NSObject>
@required
- (NSInteger)numberOfColsCollectionView:(UICollectionView *)collectionView;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForColAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfRowsCollectionView:(UICollectionView *)collectionView;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

@interface SJScrollCollectionView : UIScrollView <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id<SJScrollCollectionViewDelegate> collectionViewDelegate;
@property (weak, nonatomic) id<SJScrollCollectionViewDataSource> collectionViewDataSource;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (assign, nonatomic) NSInteger numberOfColsInPage;
@property (nonatomic) BOOL allowsSelection; // default is YES
@property (nonatomic) BOOL allowsMultipleSelection; // default is NO

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout;

// adapt CollectionView's functions

- (void)registerClass:(__unsafe_unretained Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;

- (void)registerClass:(__unsafe_unretained Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableSupplementaryViewOfKind:(NSString*)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;

- (NSArray *)indexPathsForSelectedCols;
- (void)selectColAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (void)reloadData;

- (NSInteger)numberOfRows;
- (NSInteger)numberOfCols;

- (UICollectionViewLayoutAttributes *)layoutAttributesForColAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForColAtPoint:(CGPoint)point;
- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell;

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)visibleCells;
- (NSArray *)indexPathsForVisibleItems;

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)insertRows:(NSIndexSet *)rows;
- (void)deleteRows:(NSIndexSet *)rows;
- (void)reloadRows:(NSIndexSet *)rows;
- (void)moveRow:(NSInteger)row toRow:(NSInteger)newRow;

- (void)insertCols:(NSIndexSet *)cols;
- (void)deleteCols:(NSIndexSet *)cols;
- (void)reloadCols:(NSIndexSet *)cols;
- (void)moveCol:(NSInteger)col toCol:(NSInteger)newCol;

@end

@interface NSIndexPath (SJScrollCollectionView)

+ (NSIndexPath *)indexPathForTableCol:(NSInteger)tableCol inTableRow:(NSInteger)tableRow;

@property (nonatomic, readonly) NSInteger tableCol;
@property (nonatomic, readonly) NSInteger tableRow;

@end