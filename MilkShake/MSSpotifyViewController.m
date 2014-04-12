//
//  MSSpotifyViewController.m
//  MilkShake
//
//  Created by David Weissler on 4/12/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "MSSpotifyViewController.h"
#import <Spotify/Spotify.h>
#import "MSSpotifySearchResultsCollectionController.h"

// Constants
static NSString * const kClientId = @"spotify-ios-sdk-beta";
static NSString * const kCallbackURL = @"spotify-ios-sdk-beta://callback";
static NSString * const kTokenSwapURL = @"http://localhost:1234/swap";

@interface MSSpotifyViewController ()
@property (nonatomic, strong) SPTSession *session;
@end

@implementation MSSpotifyViewController

+(MSSpotifyViewController *)sharedController
{
    static MSSpotifyViewController *shared;
    @synchronized(self)
    {
        if(!shared)
        {
            shared = [[MSSpotifyViewController alloc]init];
        }
    }
    return shared;
}

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
    [self.view setBackgroundColor:[UIColor redColor]];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 100, 15)];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeView)forControlEvents:UIControlEventTouchUpInside];
    
    // Create SPTAuth instance; create login URL and open it
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSURL *loginURL = [auth loginURLForClientId:kClientId
                            declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                         scopes:@[@"login"]];
    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    
    [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:loginURL afterDelay:0.1];

}

- (BOOL)localAuthCallback:(NSURL *)url
{
    MSSpotifySearchResultsCollectionController *searchController = [UIStoryboard storyboardWithName:@"SpotifyStoryboard" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    
    [self presentViewController:searchController animated:YES completion:^{}];
    
    
    if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
        
        // Call the token swap service to get a logged in session
        [[SPTAuth defaultInstance]
         handleAuthCallbackWithTriggeredAuthURL:url
         tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapURL]
         callback:^(NSError *error, SPTSession *session) {
             
             if (error != nil) {
                 NSLog(@"*** Auth error: %@", error);
                 return;
             }
             self.session = session;
             // Call the -playUsingSession: method to play a track
             [self playUsingSession:session];
         }];
        return YES;
    }
    
    return NO;
}

-(void)playUsingSession:(SPTSession *)session
{
    // Create a new track player if needed
    if (self.trackPlayer == nil) {
        self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Your-Company-Name"
                                                               appName:@"MilkShake"];
    }
    
    [self.trackPlayer enablePlaybackWithSession:session callback:^(NSError *error) {
        
        if (error != nil) {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:4L1HDyfdGIkACuygktO7T7"]
                         withSession:nil
                            callback:^(NSError *error, SPTAlbum *album) {
                                
                                if (error != nil) {
                                    NSLog(@"*** Album lookup got error %@", error);
                                    return;
                                }
                                
                                [self.trackPlayer playTrackProvider:album];
                                
                            }];
    }];
    
}

- (void)playItemAtURI:(SPTPartialAlbum *)partialAlbum withOffset:(NSInteger)offset
{
    // Create a new track player if needed
    if (self.trackPlayer == nil) {
        self.trackPlayer = [[SPTTrackPlayer alloc] initWithCompanyName:@"Your-Company-Name"
                                                               appName:@"MilkShake"];
    }
    
    [SPTRequest requestItemFromPartialObject:partialAlbum
                                 withSession:nil
                                    callback:^(NSError *error, id object) {
                                        if (error != nil) {
                                            NSLog(@"*** Album lookup got error %@", error);
                                            return;
                                        }
                                        if ([object isKindOfClass:[SPTAlbum class]]) {
                                            SPTAlbum *album = (SPTAlbum *)object;
                                            [self.trackPlayer playTrackProvider:album fromIndex:offset];
                                        }
                                        
                                    }];
}

-(void)closeView
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{}];
}
@end
