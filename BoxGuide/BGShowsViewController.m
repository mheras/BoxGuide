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
@property (nonatomic, strong) NSMutableArray *shows;

@end

@implementation BGShowsViewController

- (id)init {
    self = [super init];
    if (self) {
        self.shows = [[NSMutableArray alloc] init];
        for (int i = 0; i < 1000; i++) {
            BGShow *show = [[BGShow alloc] init];
            show.title = [NSString stringWithFormat:@"Title %d", i];
            [self.shows addObject:show];
        }
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SeriesCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // TODO: Continue here.
    // [[BGService sharedInstance] tre]
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
