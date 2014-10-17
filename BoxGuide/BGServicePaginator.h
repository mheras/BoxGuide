//
//  BGServicePaginator.h
//  BoxGuide
//
//  Created by Martin Heras on 10/16/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectManager;
@class RKMapping;

@interface BGServicePaginator : NSObject

@property (nonatomic, strong, readonly) NSArray *allResults;
@property (nonatomic, assign, readonly) NSInteger totalPages;
@property (nonatomic, assign, readonly) NSInteger totalResults;
@property (nonatomic, assign, readonly) NSInteger loadedPages;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

- (id)initWithManager:(RKObjectManager *)manager resultsMapping:(RKMapping *)resultsMapping path:(NSString *)path parameters:(NSDictionary *)parameters;

- (void)loadNextPageWithSuccessBlock:(void (^)(NSArray *pageResults))successBlock failureBlock:(void (^)(NSError *error))failureBlock;
- (BOOL)hasMorePages;
- (void)reset;
- (void)cancel;

@end
