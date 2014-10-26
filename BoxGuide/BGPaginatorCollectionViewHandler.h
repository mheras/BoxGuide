//
//  BGPaginatorCollectionViewHandler.h
//  BoxGuide
//
//  Created by Martin Heras on 10/26/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BGCollectionViewCell;
@class BGModel;
@protocol BGPaginator;

@interface BGPaginatorCollectionViewHandler : NSObject <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (id)initWithCollectionView:(UICollectionView *)collectionView paginator:(id<BGPaginator>)paginator cellClassName:(NSString *)cellClassName updateCellBlock:(void (^)(BGCollectionViewCell *cell, id object))updateCellBlock;

@end
