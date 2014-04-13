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

@interface MSSpotifySearchResultsCollectionController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableArray *albumSearchResults;
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
    self.albumSearchResults = [[NSMutableArray alloc] init];
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
    if (self.albumSearchResults.count > 0 && indexPath.row <= self.albumSearchResults.count - 1) {
        [cell.image setImage:self.albumSearchResults[indexPath.row]];
    }
    return cell;
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
    [self.searchBar resignFirstResponder];
    
    NSString *searchString = searchBar.text;
    [SPTRequest performSearchWithQuery:searchString queryType:SPTQueryTypeTrack session:nil
                              callback:^(NSError *error, id object) {
                                  if (error != nil) {
                                      NSLog(@"*** Album lookup got error %@", error);
                                      return;
                                  }
                                  if ([object isKindOfClass:[NSArray class]]) {
                                      [self setSearchResults:object];
                                      for (SPTTrack *track in self.searchResults) {
                                          [self loadAlbumArtForTrack:track];
                                      }
                                      [self.collectionView reloadData];
                                      NSLog(@"%@",object);
                                  }
                              }];
}

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
                                            [self.albumSearchResults addObject:[UIImage imageWithData:imageData]];
                                            [self.collectionView reloadData];
                                        }
                                    }];
}

@end
