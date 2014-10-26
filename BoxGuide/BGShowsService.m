//
//  BGShowsService.m
//  BoxGuide
//
//  Created by Martin Heras on 09/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGShowsService.h"
#import "BGShow.h"
#import <RestKit/RestKit.h>

@implementation BGShowsService

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BGShowsService *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BGShowsService alloc] initPrivate];
    });
    return sharedInstance;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)init {
    NSAssert(NO, @"Cannot instantiate singleton.");
    return nil;
}

- (RKMapping *)showMapping {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BGShow class]];
    [mapping addAttributeMappingsFromDictionary:@{@"name" : @"name", @"poster_path" : @"posterPath"}];
    
    return mapping;
}

- (BGServicePaginator *)createPopularShowsPaginator {
    return [[BGServicePaginator alloc] initWithManager:self.manager objectMapping:[self showMapping] path:@"/3/tv/popular" parameters:@{@"api_key" : kAPIKey} cacheKey:@"CACHEKEY"]; // TODO: Cache key!
}

@end
