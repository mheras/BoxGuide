//
//  BGShowsViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/7/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGShowsViewController.h"
#import "BGShow.h"
#import "BGShowsService.h"

@interface BGShowsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *shows;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation BGShowsViewController

- (id)init {
    self = [super init];
    if (self) {
        // TODO: Do something.
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // TODO: Reuse identifier is hardcoded!
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SeriesCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadContent];
}

- (void)refreshContent {
    [self loadContent];
}

- (void)loadContent {
    
    __weak typeof(self) weakSelf = self;
    [[BGShowsService sharedInstance] trendingShowsWithSuccessBlock:^(NSArray *shows) {
        weakSelf.shows = shows;
        [weakSelf.collectionView reloadData];
        [weakSelf.refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        // TODO: Implement this!
        [weakSelf.refreshControl endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.shows count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SeriesCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
