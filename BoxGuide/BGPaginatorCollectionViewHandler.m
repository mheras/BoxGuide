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

@interface BGPaginatorCollectionViewFooter : UICollectionReusableView
@end

@implementation BGPaginatorCollectionViewFooter

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce];
        [self addSubview:spinner];
        
        spinner.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    }
    return self;
}

@end

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
        [self.collectionView registerClass:[BGPaginatorCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([BGPaginatorCollectionViewFooter class])];
        
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
    
    [self enableFooter:YES];
    
    self.spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleCircle];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.collectionView.superview addSubview:self.spinner];
    
    [self.collectionView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.collectionView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self loadMore];
}

- (void)enableFooter:(BOOL)enable {
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).footerReferenceSize = CGSizeMake(0.0f, enable ? 20.0f : 0.0f);
}

- (void)loadMore {
    
    BGToWeak(self, weakSelf);
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
                [weakSelf enableFooter:[weakSelf.paginator hasMorePages]];
                if ([weakSelf.paginator hasMorePages] && [weakSelf isLastObjectVisible]) {
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([BGPaginatorCollectionViewFooter class]) forIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.loadedObjects.count - 1 && ![self.paginator isLoading] && [self.paginator hasMorePages]) {
        [self loadMore];
    }
}

@end
