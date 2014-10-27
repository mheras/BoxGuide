//
//  BGPaginatorCollectionViewHandler.m
//  BoxGuide
//
//  Created by Martin Heras on 10/26/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGPaginatorCollectionViewHandler.h"
#import "BGCollectionViewCell.h"
#import "BGPaginator.h"
#import <SpinKit/RTSpinKitView.h>

@interface BGPaginatorCollectionViewHandler ()

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) id<BGPaginator> paginator;
@property (nonatomic, strong) NSMutableArray *loadedObjects;
@property (nonatomic, copy) void (^updateCellBlock)(BGCollectionViewCell *cell, id object);
@property (nonatomic, copy) NSString *cellClassName;

@property (nonatomic, strong) RTSpinKitView *spinner;

@end

@implementation BGPaginatorCollectionViewHandler

- (id)initWithCollectionView:(UICollectionView *)collectionView paginator:(id<BGPaginator>)paginator cellClassName:(NSString *)cellClassName updateCellBlock:(void (^)(BGCollectionViewCell *cell, id object))updateCellBlock {
    self = [super init];
    if (self) {
        
        self.collectionView = collectionView;
        self.updateCellBlock = updateCellBlock;
        self.paginator = paginator;
        self.cellClassName = cellClassName;
        self.loadedObjects = [[NSMutableArray alloc] init];
        
        NSAssert([NSClassFromString(cellClassName) isSubclassOfClass:[BGCollectionViewCell class]], @"The given cell class name does not correspond to a subclass of BGCollectionViewCell");
        
        [self.collectionView registerNib:[UINib nibWithNibName:self.cellClassName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:self.cellClassName];
        
        [self setupCollectionViewForPagination];
    }
    return self;
}

- (void)setupCollectionViewForPagination {
    
    // Make it always bounce vertically, so that the refresh control works even when
    // the displayed items don't cover the whole screen.
    self.collectionView.alwaysBounceVertical = YES;

    // Make it transparent so that we can display the spinner.
    self.collectionView.alpha = 0.0f;
    
    /*
     
     RTSpinKitViewStylePlane,
     RTSpinKitViewStyleCircleFlip,
     RTSpinKitViewStyleBounce, ##
     RTSpinKitViewStyleWave, ##
     RTSpinKitViewStyleWanderingCubes,
     RTSpinKitViewStylePulse,
     RTSpinKitViewStyleChasingDots,
     RTSpinKitViewStyleThreeBounce, ## perfecto para el paginado de footer
     RTSpinKitViewStyleCircle, ## es como un refresh comun, pero mejor animado. puede ir para el main.
     RTSpinKitViewStyle9CubeGrid,
     RTSpinKitViewStyleWordPress,
     RTSpinKitViewStyleFadingCircle,
     RTSpinKitViewStyleFadingCircleAlt, ## similar al Circle
     RTSpinKitViewStyleArc, ## circulo casi completo
     RTSpinKitViewStyleArcAlt
     
     */
    
    self.spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.collectionView.superview addSubview:self.spinner];
    
    [self.collectionView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.collectionView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self loadMore];
}

- (void)loadMore {
    
    __weak typeof(self) weakSelf = self;
    
    if (![self.paginator isLoading] && [self.paginator hasMorePages]) {
        [self.paginator loadNextPageWithSuccessBlock:^(NSInteger page, NSArray *pageObjects) {
            
            NSInteger previousCount = weakSelf.loadedObjects.count;
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] initWithCapacity:pageObjects.count];
            for (NSInteger i = 0; i < pageObjects.count; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForItem:i + previousCount inSection:0]];
            }
            
            [weakSelf.loadedObjects addObjectsFromArray:pageObjects];
            
            [weakSelf.collectionView performBatchUpdates:^{
                [weakSelf.collectionView insertItemsAtIndexPaths:indexPathsToInsert];
            } completion:^(BOOL finished) {
                if ([weakSelf isLastObjectVisible] && [weakSelf.paginator hasMorePages]) {
                    [weakSelf loadMore];
                } else {
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.spinner.alpha = 0.0f;
                        weakSelf.collectionView.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        [weakSelf.spinner removeFromSuperview];
                    }];
                }
            }];
            
        } failureBlock:^(NSError *error) {
            // TODO: Implement this!
            NSLog(@"Paginator error: %@", [error localizedDescription]);
        }];
    }
}

- (BOOL)isLastObjectVisible {
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForVisibleItems]) {
        if (indexPath.item == self.loadedObjects.count - 1) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.loadedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellClassName forIndexPath:indexPath];
    id object = self.loadedObjects[indexPath.item];
    if (self.updateCellBlock != nil) {
        self.updateCellBlock(cell, object);
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.paginator isLoading] && [self.paginator hasMorePages] && [self isLastObjectVisible]) {
        [self loadMore];
    }
}

@end
