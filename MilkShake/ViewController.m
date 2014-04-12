//
//  ViewController.m
//  MilkShake
//
//  Created by Daniel Rakhamimov on 4/12/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "ViewController.h"
#import "MSSpotifyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)spotifyButtonDidTouch:(UIButton *)sender
{
    MSSpotifyViewController *spotifyVC = [[MSSpotifyViewController alloc] init];
    [self presentViewController:spotifyVC
                       animated:YES
                     completion:^{
                     }];
}

@end
