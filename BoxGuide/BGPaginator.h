//
//  BGPaginator.h
//  BoxGuide
//
//  Created by Martin Heras on 10/26/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGPaginator <NSObject>

/**
 * Whether the paginator has loaded at least one time or not.
 */
@property (nonatomic, assign, readonly) BOOL hasLoaded;

/**
 * The number of total objects.
 */
@property (nonatomic, assign, readonly) NSInteger totalObjects;

/**
 * Whether the paginator is currently loading a page or not.
 */
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

/**
 * The cache key for the paginator.
 */
@property (nonatomic, copy, readonly) NSString *cacheKey;

/**
 * Loads the next page.
 *
 * @param successBlock The block that is called when the next page is loaded successfully.
 * @param failureBlock The block that is called when the next page couldn't be loaeded, for any reason.
 */
- (void)loadNextPageWithSuccessBlock:(void (^)(NSInteger page, NSArray *pageObjects))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

/**
 * Whether the paginator has more pages to load or not.
 */
- (BOOL)hasMorePages;

/**
 * Cancels the current loading operation.
 */
- (void)cancel;

/**
 * Invalidates the paginator making the next loading operation to load the first page again.
 */
- (void)reset;

/**
 * Clears the cache so that the next loading operations fetch data with requests.
 */
- (void)clearCache;

@end
