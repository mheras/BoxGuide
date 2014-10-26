//
//  BGServicePaginator.h
//  BoxGuide
//
//  Created by Martin Heras on 10/16/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGPaginator.h"

@class RKObjectManager;
@class RKMapping;

/**
 * A paginator that loads its objects from a service.
 */
@interface BGServicePaginator : NSObject <BGPaginator>

/**
 * Instantiates a new paginator.
 *
 * @param manager The manager to be used to make the requests.
 * @param objectMapping The mapping for the objects being paginated.
 * @param path The relative path for this resource.
 * @param parameters The parameters to add as part of the query string in the requests.
 * @param cacheKey The cache key to be used by this paginator to cache the objects. If nil is provided, no cache is used.
 */
- (id)initWithManager:(RKObjectManager *)manager objectMapping:(RKMapping *)objectMapping path:(NSString *)path parameters:(NSDictionary *)parameters cacheKey:(NSString *)cacheKey;

@end
