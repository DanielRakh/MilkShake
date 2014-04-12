//
//  MSSpotifyViewController.h
//  MilkShake
//
//  Created by David Weissler on 4/12/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSpotifyViewController : UIViewController

+(MSSpotifyViewController *)sharedController;
- (BOOL)localAuthCallback:(NSURL *)url;
@end
