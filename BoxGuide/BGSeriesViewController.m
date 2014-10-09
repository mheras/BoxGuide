//
//  BGSeriesViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/7/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGSeriesViewController.h"
#import "BGSeries.h"

@interface BGSeriesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *seriesDataSource;

@end

@implementation BGSeriesViewController

- (id)init {
    self = [super init];
    if (self) {
        self.seriesDataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 1000; i++) {
            BGSeries *series = [[BGSeries alloc] init];
            series.title = [NSString stringWithFormat:@"Title %d", i];
            [self.seriesDataSource addObject:series];
        }
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SeriesCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.seriesDataSource count];
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
