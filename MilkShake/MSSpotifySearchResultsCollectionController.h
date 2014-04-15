//
//  MSSpotifySearchResultsCollectionController.h
//  MilkShake
//
//  Created by David Weissler on 4/12/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSLoadingView;

@interface MSSpotifySearchResultsCollectionController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet MSLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
