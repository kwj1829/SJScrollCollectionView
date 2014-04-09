//
//  SJScrollCollectionView.m
//  SJScrollCollectionView
//
//  Created by SeokJong Gwak on 2014. 4. 3..
//  Copyright (c) 2014년 SeokJong Gwak. All rights reserved.
//

#import "SJScrollCollectionView.h"

#define NUMBER_OF_PAGES 3
#define MAX_PADDING 20

@interface SJScrollCollectionView ()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger firstPageNumber;

@end

@implementation SJScrollCollectionView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self defaultInit:frame];
        self.collectionViewLayout = layout;
        [self collectionViewInit:frame];
        [self setNumberOfColsInPage:1];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
}

- (void)defaultInit:(CGRect)frame
{
    self.firstPageNumber = 0;
    [self setContentSize:CGSizeMake(frame.size.width * NUMBER_OF_PAGES, frame.size.height)];
    self.scrollEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
}

- (void)collectionViewInit:(CGRect)frame
{
    self.collectionView = [self collectionViewMakeWithLayout:self.collectionViewLayout];
    [self.collectionView setFrame:CGRectMake(0, 0, frame.size.width * NUMBER_OF_PAGES, frame.size.height)];
    
    [self addSubview:self.collectionView];
    [self scrollRectToVisible:self.bounds animated:NO];
}

- (UICollectionView *)collectionViewMakeWithLayout:(UICollectionViewLayout *)layout
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    
    return collectionView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSAssert([self.collectionViewDataSource respondsToSelector:@selector(numberOfColsCollectionView:)], @"SJCollectionView // collectionViewDataSource must implement - (NSInteger)numberOfColsCollectionView:(UICollectionView *)collectionView");
    
    NSInteger numberOfItems = [self.collectionViewDataSource numberOfColsCollectionView:self.collectionView];
    
    if (self.contentOffset.x == self.frame.size.width) {
        return;
    } else if (self.contentOffset.x > self.frame.size.width) {
        if (self.firstPageNumber == ceill((double)numberOfItems / (double)self.numberOfColsInPage) - NUMBER_OF_PAGES) {
            return;
        }
        self.firstPageNumber++;
    } else if (self.contentOffset.x < self.frame.size.width) {
        if (self.firstPageNumber == 0) {
            return;
        }
        self.firstPageNumber--;
    }
    
    [self reloadData];
    [self scrollRectToVisible:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height) animated:NO];
}

#pragma mark - UICollectionView's adapt functions

- (void)registerClass:(__unsafe_unretained Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[self indexPathToSJIndexPath:indexPath]];
}

- (void)registerClass:(__unsafe_unretained Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
}

- (id)dequeueReusableSupplementaryViewOfKind:(NSString*)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath
{
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:[self indexPathToSJIndexPath:indexPath]];
}

- (NSArray *)indexPathsForSelectedCols
{
    return self.collectionView.indexPathsForSelectedItems;
}

- (void)selectColAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    [self.collectionView selectItemAtIndexPath:[self indexPathToSJIndexPath:indexPath] animated:animated scrollPosition:scrollPosition];
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self.collectionView deselectItemAtIndexPath:[self indexPathToSJIndexPath:indexPath] animated:animated];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (NSInteger)numberOfRows
{
    return self.collectionView.numberOfSections;
}

- (NSInteger)numberOfCols
{
    return [self.collectionView numberOfItemsInSection:0];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForColAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView layoutAttributesForItemAtIndexPath:[self indexPathToSJIndexPath:indexPath]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView layoutAttributesForSupplementaryElementOfKind:kind atIndexPath:[self indexPathToSJIndexPath:indexPath]];
}

- (NSIndexPath *)indexPathForColAtPoint:(CGPoint)point
{
    return [self SJIndexPathToIndexPath:[self.collectionView indexPathForItemAtPoint:point]];
}

- (NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell
{
    return [self SJIndexPathToIndexPath:[self.collectionView indexPathForCell:cell]];
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView cellForItemAtIndexPath:[self indexPathToSJIndexPath:indexPath]];
}

- (NSArray *)visibleCells
{
    return [self.collectionView visibleCells];
}

- (NSArray *)indexPathsForVisibleItems
{
    return [self.collectionView indexPathsForVisibleItems];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSInteger col = indexPath.tableCol;
    NSInteger currentCol = self.firstPageNumber * (self.numberOfColsInPage + 1);
    
    if (currentCol > col) {
        self.firstPageNumber = (currentCol - col) / self.numberOfColsInPage;
    } else {
        self.firstPageNumber = (col - currentCol) / self.numberOfColsInPage;
    }
    
    [self scrollViewDidEndDecelerating:self];
    [self.collectionView scrollToItemAtIndexPath:[self indexPathToSJIndexPath:indexPath] atScrollPosition:scrollPosition animated:animated];
}

- (void)setAllowsSelection:(BOOL)allowsSelection
{
    [self.collectionView setAllowsSelection:allowsSelection];
}

- (BOOL)allowsSelection
{
    return self.collectionView.allowsSelection;
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    [self.collectionView setAllowsMultipleSelection:allowsMultipleSelection];
}

- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}

- (void)insertRows:(NSIndexSet *)tableRows
{
    [self.collectionView insertSections:tableRows];
}

- (void)deleteRows:(NSIndexSet *)tableRows
{
    [self.collectionView deleteSections:tableRows];
}

- (void)reloadRows:(NSIndexSet *)tableRows
{
    [self.collectionView reloadSections:tableRows];
}

- (void)moveRow:(NSInteger)tableRow toRow:(NSInteger)newTableRow
{
    [self.collectionView moveSection:tableRow toSection:newTableRow];
}

- (void)insertCols:(NSIndexSet *)cols
{
    [self.collectionView performBatchUpdates:^{
        NSArray *processIndexPaths = [self processIndexPathsWithCols:cols];
        NSArray *lastColsIndexPaths = [self lastColsIndexPathsByCount:processIndexPaths.count / [self numberOfRows]];
        
        [self.collectionView deleteItemsAtIndexPaths:lastColsIndexPaths];
        [self.collectionView insertItemsAtIndexPaths:processIndexPaths];
    } completion:^(BOOL finished) {
        ; // do nothing
    }];
}

- (void)deleteCols:(NSIndexSet *)cols
{
    [self.collectionView performBatchUpdates:^{
        NSArray *processIndexPaths = [self processIndexPathsWithCols:cols];
        NSArray *lastColsIndexPaths = [self lastColsIndexPathsByCount:processIndexPaths.count / [self numberOfRows]];
        
        [self.collectionView deleteItemsAtIndexPaths:processIndexPaths];
        [self.collectionView insertItemsAtIndexPaths:lastColsIndexPaths];
    } completion:^(BOOL finished) {
        ; // do nothing
    }];
}

- (void)reloadCols:(NSIndexSet *)cols
{
    [self.collectionView performBatchUpdates:^{
        NSArray *processIndexPaths = [self processIndexPathsWithCols:cols];
        
        [self.collectionView reloadItemsAtIndexPaths:processIndexPaths];
    } completion:^(BOOL finished) {
        ; // do nothing
    }];
}

- (void)moveCol:(NSInteger)col toCol:(NSInteger)newCol
{
    NSInteger moveCol = [self indexPathColToSJTableCol:col] > [self lastColIndex] ? [self lastColIndex] : [self indexPathColToSJTableCol:col];
    NSInteger toCol = [self indexPathColToSJTableCol:newCol] > [self lastColIndex] ? [self lastColIndex] : [self indexPathColToSJTableCol:newCol];
    
    [self.collectionView performBatchUpdates:^{
        for (NSInteger row = 0; row < [self numberOfRows]; row++) {
            [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForTableCol:moveCol inTableRow:row] toIndexPath:[NSIndexPath indexPathForTableCol:toCol inTableRow:row]];
        }
    } completion:^(BOOL finished) {
        NSMutableIndexSet *reloadIndexSet = [NSMutableIndexSet indexSetWithIndex:moveCol];
        [reloadIndexSet addIndex:toCol];
        [self reloadCols:reloadIndexSet];
    }];
}

#pragma mark - SJScrollCollectionView helper functions

- (NSIndexPath *)SJIndexPathToIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableCol = [self SJTableColToIndexPathCol:indexPath.tableCol];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForTableCol:tableCol inTableRow:indexPath.tableRow];
    return currentIndexPath;
}

- (NSIndexPath *)indexPathToSJIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tableCol = [self indexPathColToSJTableCol:indexPath.tableCol];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForTableCol:tableCol inTableRow:indexPath.tableRow];
    return currentIndexPath;
}

- (NSInteger)indexPathColToSJTableCol:(NSInteger)tableCol
{
    return (tableCol - self.firstPageNumber * self.numberOfColsInPage) < 0 ? 0 : tableCol - self.firstPageNumber * self.numberOfColsInPage;
}

- (NSInteger)SJTableColToIndexPathCol:(NSInteger)tableCol
{
    return tableCol + self.firstPageNumber * self.numberOfColsInPage;
}

- (NSArray *)processIndexPathsWithCols:(NSIndexSet *)cols
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSUInteger col = [cols firstIndex];
    NSInteger tableCol = [self indexPathColToSJTableCol:col];
    
    while (col != NSNotFound && tableCol < self.numberOfColsInPage * NUMBER_OF_PAGES) {
        for (NSInteger tableRow = 0; tableRow < self.numberOfRows; tableRow++) {
            [indexPaths addObject:[NSIndexPath indexPathForTableCol:tableCol inTableRow:tableRow]];
        }
        col = [cols indexGreaterThanIndex:col];
        tableCol = [self indexPathColToSJTableCol:col];
    }
    
    return indexPaths;
}

- (NSInteger)lastColIndex
{
    return (self.numberOfColsInPage * NUMBER_OF_PAGES) - 1;
}

- (NSArray *)lastColIndexPaths
{
    NSMutableArray *lastIndexPaths = [NSMutableArray array];
    
    for (NSInteger tableRow = 0; tableRow < self.numberOfRows; tableRow++) {
        [lastIndexPaths addObject:[NSIndexPath indexPathForTableCol:[self lastColIndex] inTableRow:tableRow]];
    }

    return lastIndexPaths;
}

- (NSArray *)lastColsIndexPathsByCount:(NSInteger)count
{
    NSMutableArray *lastColsIndexPaths = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        [lastColsIndexPaths addObjectsFromArray:[self lastColIndexPaths]];
    }
    
    return lastColsIndexPaths;
}

- (void)setNumberOfColsInPage:(NSInteger)numberOfColsInPage
{
    _numberOfColsInPage = numberOfColsInPage;
    CGFloat padding = MAX_PADDING / numberOfColsInPage;
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    self.collectionViewLayout.minimumInteritemSpacing = padding * 2 - 0.01;
    CGFloat size = (self.bounds.size.width - padding * numberOfColsInPage * 2) / numberOfColsInPage;
    self.collectionViewLayout.itemSize = CGSizeMake(size, size);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.collectionViewDataSource respondsToSelector:@selector(numberOfRowsCollectionView:)]) {
        return [self.collectionViewDataSource numberOfRowsCollectionView:collectionView];
    }
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSAssert([self.collectionViewDataSource respondsToSelector:@selector(numberOfColsCollectionView:)], @"SJCollectionView // collectionViewDataSource must implement - (NSInteger)numberOfColsCollectionView:(UICollectionView *)collectionView");
    
    NSInteger numberOfItems = [self.collectionViewDataSource numberOfColsCollectionView:collectionView];
    
    NSInteger numberOfItemsInSection = numberOfItems - self.firstPageNumber * self.numberOfColsInPage;
    
    if (numberOfItemsInSection <= 0) {
        return 0;
    } else if (numberOfItemsInSection < self.numberOfColsInPage * NUMBER_OF_PAGES) {
        return numberOfItemsInSection;
    }
    
    return self.numberOfColsInPage * NUMBER_OF_PAGES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert([self.collectionViewDataSource respondsToSelector:@selector(collectionView:cellForColAtIndexPath:)], @"SJCollectionView // collectionViewDataSource must implement - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForColAtIndexPath:(NSIndexPath *)indexPath");
    
    return [self.collectionViewDataSource collectionView:collectionView
                                  cellForColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewDataSource collectionView:collectionView
                       viewForSupplementaryElementOfKind:kind
                                             atIndexPath:[self SJIndexPathToIndexPath:indexPath]];;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewDelegate collectionView:collectionView
                        shouldHighlightColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionViewDelegate collectionView:collectionView
                    didHighlightColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionViewDelegate collectionView:collectionView
                  didUnhighlightColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewDelegate collectionView:collectionView
                           shouldSelectColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewDelegate collectionView:collectionView
                         shouldDeselectColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionViewDelegate collectionView:collectionView
                       didSelectColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionViewDelegate collectionView:collectionView
                     didDeselectColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionViewDelegate collectionView:collectionView
                           didEndDisplayingCell:cell
                             forColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionViewDelegate collectionView:collectionView
              didEndDisplayingSupplementaryView:view
                               forElementOfKind:elementKind
                                    atIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionViewDelegate collectionView:collectionView
                      shouldShowMenuForColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return [self.collectionViewDelegate collectionView:collectionView
                                      canPerformAction:action
                                     forColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]
                                            withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    [self.collectionViewDelegate collectionView:collectionView
                                  performAction:action
                              forColAtIndexPath:[self SJIndexPathToIndexPath:indexPath]
                                     withSender:sender];
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    return [self.collectionViewDelegate collectionView:collectionView
                          transitionLayoutForOldLayout:fromLayout newLayout:toLayout];
}

@end

@implementation NSIndexPath (SJScrollCollectionView)

+ (NSIndexPath *)indexPathForTableCol:(NSInteger)tableCol inTableRow:(NSInteger)tableRow
{
    return [NSIndexPath indexPathForItem:tableCol inSection:tableRow];
}

- (NSInteger)tableCol
{
    return self.item;
}

- (NSInteger)tableRow
{
    return self.section;
}

@end