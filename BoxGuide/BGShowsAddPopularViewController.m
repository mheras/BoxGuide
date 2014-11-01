//
//  BGShowsAddPopularViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/7/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGShowsAddPopularViewController.h"
#import "BGShow.h"
#import "BGShowsService.h"
#import "BGAddShowCollectionViewCell.h"
#import "BGPaginatorCollectionViewHandler.h"

@interface BGShowsAddPopularViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) BGPaginatorCollectionViewHandler *handler;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) BGServicePaginator *popularShowsPaginator;

@end

@implementation BGShowsAddPopularViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.handler = [[BGPaginatorCollectionViewHandler alloc] initWithCollectionView:self.collectionView paginator:[[BGShowsService sharedInstance] createPopularShowsPaginator] cellClassName:NSStringFromClass([BGAddShowCollectionViewCell class]) updateCellBlock:^(BGCollectionViewCell *cell, id object) {
        
        BGAddShowCollectionViewCell *addShowCell = (BGAddShowCollectionViewCell *)cell;
        BGShow *show = (BGShow *)object;
        
        addShowCell.name = show.name;
        // TODO: Improve this! Do it somewhere else and use prepareCell to reset the cell with default values instead of setting nil.
        if (show.posterPath) {
            addShowCell.posterUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w342%@", show.posterPath]];
        } else {
            addShowCell.posterUrl = nil;
        }
    }];
    
    self.collectionView.dataSource = self.handler;
    self.collectionView.delegate = self.handler;
    
    //self.refreshControl = [[UIRefreshControl alloc] init];
    //[self.collectionView addSubview:self.refreshControl];
    //[self.refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
}

- (NSString *)title {
    return NSLocalizedString(@"ShowsAddPopular.Title", nil);
}

- (void)refreshContent {
    //[self.popularShowsPaginator invalidate];
    //[self loadNextPage];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    // Hack: We are dispatching the layout to prevent the following error:
    // ****
    // Snapshotting a view that has not been rendered results in an empty snapshot.
    // Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
    // ****
    BGToWeak(self, weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setupCollectionViewLayout];
    });
}

- (void)setupCollectionViewLayout {
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    NSInteger columns = 1 + ((NSInteger)(CGRectGetWidth(self.collectionView.frame) - layout.sectionInset.left - layout.sectionInset.right + layout.minimumInteritemSpacing)) / ((NSInteger)(layout.minimumInteritemSpacing + 300.0 + 1.0));
    
    layout.itemSize = CGSizeMake((CGRectGetWidth(self.collectionView.frame) - layout.sectionInset.left - layout.sectionInset.right - ((columns - 1) * layout.minimumInteritemSpacing)) / columns, layout.itemSize.height);
}

@end
