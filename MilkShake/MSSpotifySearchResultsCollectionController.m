//
//  MSSpotifySearchResultsCollectionController.m
//  MilkShake
//
//  Created by David Weissler on 4/12/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "MSSpotifySearchResultsCollectionController.h"
#import "MSSongCollectionViewCell.h"
#import "MSSpotifyViewController.h"
#import <Spotify/Spotify.h>
#import "MSLoadingView.h"
#import "MCManager.h"

@import MultipeerConnectivity;

@interface MSSpotifySearchResultsCollectionController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableArray *availableResults;
@property (nonatomic, strong) NSMutableDictionary *trackAndCoverDictionary;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MSSpotifySearchResultsCollectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchResults = [NSArray array];
    self.availableResults = [NSMutableArray array];
    self.trackAndCoverDictionary = [NSMutableDictionary dictionary];
}

#pragma mark - UICollectionViewDataSource Protocol
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.availableResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor blackColor]];
    SPTTrack *track = (SPTTrack *)self.availableResults[indexPath.row];
    SPTPartialArtist *partialArtist = track.artists[0];    
    [cell.artist setText:partialArtist.name];
    [cell.songTitle setText:track.name];
    NSString *key = [NSString stringWithFormat:@"%@",track.uri];
    UIImage *albumImage = self.trackAndCoverDictionary[key];
    [cell.image setImage:albumImage];
    return cell;
}


#pragma mark - UICollectionViewDelegate Protocol
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPTTrack *track = self.availableResults[indexPath.row];
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
    // Clear out old data
    [self.searchBar resignFirstResponder];
    [self.availableResults removeAllObjects]; // new search, new results
    [self.trackAndCoverDictionary removeAllObjects];
    
    // Show loading view
    [self.loadingView setHidden:NO];
    [self.view bringSubviewToFront:self.loadingView];
    
    NSString *searchString = searchBar.text;
    [SPTRequest performSearchWithQuery:searchString queryType:SPTQueryTypeTrack session:nil
                              callback:^(NSError *error, id object) {
                                  if (error != nil) {
                                      NSLog(@"*** Album lookup got error %@", error);
                                      return;
                                  }
                                  if ([object isKindOfClass:[NSArray class]]) {
                                      [self setSearchResults:object];
                                      [self filterForAvailableTracks]; // some songs not available in US
                                  }
                              }];
}

#pragma mark - Helper methods
- (void)loadAlbumArtForTrack:(SPTTrack *)track
{
    SPTPartialAlbum *partialAlbum = track.album;
    [SPTRequest requestItemFromPartialObject:partialAlbum
                                 withSession:nil
                                    callback:^(NSError *error, id object) {
                                        if (error != nil) {
                                            NSLog(@"*** Album lookup got error %@", error);
                                            return;
                                        }
                                        if ([object isKindOfClass:[SPTAlbum class]]) {
                                            SPTAlbum *album = object;
                                            NSArray *covers = album.covers;
                                            SPTImage *coverImage = covers[SPTImageSizeMedium];
                                            NSURL *coverURL = coverImage.imageURL;
                                            NSData *imageData = [[NSData alloc] initWithContentsOfURL:coverURL];
                                            NSString *key = [NSString stringWithFormat:@"%@",track.uri];
                                            [self.trackAndCoverDictionary setValue:[UIImage imageWithData:imageData] forKey:key];
                                            [self reloadCollectionView];
                                        }
                                    }];
}

- (void)filterForAvailableTracks
{
    for (SPTTrack *track in self.searchResults) {
        // For now, only make US songs available
        
        //if ([track.availableTerritories containsObject:@"US"]) {
            [self.availableResults addObject:track];
            [self loadAlbumArtForTrack:track];
       // }
    }
    
}

- (void)reloadCollectionView
{
    if (self.availableResults.count == self.trackAndCoverDictionary.count) {
        [self.collectionView reloadData];
        [self.loadingView setHidden:YES];
        [self.view sendSubviewToBack:self.loadingView];
    }
}

@end
