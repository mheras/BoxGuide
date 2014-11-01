//
//  UIImageView+URL.m
//  BoxGuide
//
//  Created by Martin Heras on 10/11/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "UIImageView+URL.h"
#import <TMCache/TMCache.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/AFImageRequestOperation.h>
#import <objc/runtime.h>

static char kBGRequestOperationObjectKey;
static char kBGURLObjectKey;

@implementation UIImageView (URL)

- (AFHTTPRequestOperation *)bg_requestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kBGRequestOperationObjectKey);
}

- (void)bg_setRequestOperation:(AFImageRequestOperation *)requestOperation {
    objc_setAssociatedObject(self, &kBGRequestOperationObjectKey, requestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)bg_url {
    return (NSURL *)objc_getAssociatedObject(self, &kBGURLObjectKey);
}

- (void)bg_setUrl:(NSURL *)url {
    objc_setAssociatedObject(self, &kBGURLObjectKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSOperationQueue *)bg_sharedImageRequestOperationQueue {
    static NSOperationQueue *imageRequestOperationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return imageRequestOperationQueue;
}

- (TMCache *)bg_imageCache {
    static dispatch_once_t onceToken;
    static TMCache *imageCache;
    dispatch_once(&onceToken, ^{
        imageCache = [[TMCache alloc] initWithName:@"ImageCache"];
    });
    return imageCache;
}

- (void)bg_setImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    
    dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{

        [self bg_setUrl:url];
        [self bg_cancelRequestOperation];
        
        self.image = placeholderImage;
        
        BGToWeak(self, weakSelf);
        [[self bg_imageCache] objectForKey:[url absoluteString] block:^(TMCache *cache, NSString *key, id object) {
            
            if ([key isEqualToString:[weakSelf.bg_url absoluteString]]) {
                UIImage *cachedImage = object;
                if (cachedImage) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.image = cachedImage;
                    });
                } else {
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
                    AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:request];
                    requestOperation.allowsInvalidSSLCertificate = YES;
                    
                    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        UIImage *downloadedImage = responseObject;
                        
                        if ([key isEqualToString:[weakSelf.bg_url absoluteString]]) {
                            if (weakSelf.bg_requestOperation == operation) {
                                [weakSelf bg_setRequestOperation:nil];
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.image = downloadedImage;
                            });
                        }
                        
                        [[weakSelf bg_imageCache] setObject:downloadedImage forKey:[operation.request.URL absoluteString] block:nil];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        if ([key isEqualToString:[weakSelf.bg_url absoluteString]]) {
                            if (weakSelf.bg_requestOperation == operation) {
                                [weakSelf bg_setRequestOperation:nil];
                            }
                        }
                        
                    }];
                    
                    [weakSelf bg_setRequestOperation:requestOperation];
                    [[weakSelf bg_sharedImageRequestOperationQueue] addOperation:[weakSelf bg_requestOperation]];
                }
            }
        }];
    });
}

- (void)bg_cancelRequestOperation {
    [[self bg_requestOperation] cancel];
    [self bg_setRequestOperation:nil];
}

@end
