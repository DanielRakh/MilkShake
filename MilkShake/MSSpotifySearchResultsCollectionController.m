//
//  MSSpotifySearchResultsCollectionController.m
//  MilkShake
//
//  Created by David Weissler on 4/12/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "MSSpotifySearchResultsCollectionController.h"
#import "MSSongCollectionViewCell.h"
#import "MSCollectionHeaderView.h"
#import "MSSpotifyViewController.h"
#import <Spotify/Spotify.h>

@interface MSSpotifySearchResultsCollectionController ()
@property (nonatomic, strong) MSCollectionHeaderView *headerView;
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation MSSpotifySearchResultsCollectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.searchResults = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource Protocol
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blueColor]];
    SPTTrack *track = (SPTTrack *)self.searchResults[indexPath.row];
    SPTPartialArtist *partialArtist = track.artists[0];

    NSString *title = track.name;
    NSString *artist = partialArtist.name;
    NSString *cellTitle = [artist stringByAppendingString:@" - "];
    cellTitle = [cellTitle stringByAppendingString:title];
    [cell.songTitle setText:cellTitle];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        MSCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;
        [headerView.searchBar setDelegate:self];
        [self setHeaderView:headerView];
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegate Protocol
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPTTrack *track = self.searchResults[indexPath.row];
    SPTPartialAlbum *album = track.album;
    NSInteger offset = track.trackNumber - 1;
    offset = (offset < 0) ? 0 : offset;
    [[MSSpotifyViewController sharedController] playItemAtURI:album withOffset:offset];
}

#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.headerView.searchBar resignFirstResponder];
    
    NSString *searchString = searchBar.text;
    [SPTRequest performSearchWithQuery:searchString queryType:SPTQueryTypeTrack session:nil
                              callback:^(NSError *error, id object) {
                                  if (error != nil) {
                                      NSLog(@"*** Album lookup got error %@", error);
                                      return;
                                  }
                                  if ([object isKindOfClass:[NSArray class]]) {
                                      [self setSearchResults:object];
                                      [self.collectionView reloadData];
                                      NSLog(@"%@",object);
                                  }
                              }];
}

@end
