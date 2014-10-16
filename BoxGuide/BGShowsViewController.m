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
#import "BGAddShowCollectionViewCell.h"

@interface BGShowsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *shows;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

// TODO: Order methods alphabetically.

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
    
    NSString *addShowCellClass = NSStringFromClass([BGAddShowCollectionViewCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:addShowCellClass bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:addShowCellClass];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadContent];
    
    /*
    NSMutableArray *p = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4234; i++) {
        BGShow *s = [[BGShow alloc ] init];
        s.title = [NSString stringWithFormat:@"%d" ,i];
        [p addObject:s];
    }
    self.shows = p;
    */
}

- (void)refreshContent {
    [self loadContent];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    // Hack: We are dispatching the layout to prevent the following error:
    // ****
    // Snapshotting a view that has not been rendered results in an empty snapshot.
    // Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates.
    // ****
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupCollectionViewLayout];
    });
}

- (void)loadContent {
    
    __weak typeof(self) weakSelf = self;
    [[BGShowsService sharedInstance] popularShowsWithSuccessBlock:^(NSArray *shows) {
        weakSelf.shows = shows;
        [weakSelf.collectionView reloadData];
        [weakSelf.refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        // TODO: Implement this!
        [weakSelf.refreshControl endRefreshing];
    }];
}

- (void)setupCollectionViewLayout {
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    NSInteger columns = 1 + ((NSInteger)(CGRectGetWidth(self.collectionView.frame) - layout.sectionInset.left - layout.sectionInset.right + layout.minimumInteritemSpacing)) / ((NSInteger)(layout.minimumInteritemSpacing + 300.0 + 1.0));
    
    layout.itemSize = CGSizeMake((CGRectGetWidth(self.collectionView.frame) - layout.sectionInset.left - layout.sectionInset.right - ((columns - 1) * layout.minimumInteritemSpacing)) / columns, layout.itemSize.height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.shows count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BGShow *show = self.shows[indexPath.row];
    
    BGAddShowCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BGAddShowCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.name = show.name;
    cell.posterUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w342%@", show.posterPath]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
