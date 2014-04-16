//
//  SecondViewController.m
//  MilkShake
//
//  Created by Daniel Rakhamimov on 4/14/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "SecondViewController.h"
#import "MCManager.h"
@import MultipeerConnectivity;

@interface SecondViewController () <MCNearbyServiceBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *peerIDArray;

@end

@implementation SecondViewController

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
    
 
    [[MCManager sharedManager] setupBrowser];
    [[[MCManager sharedManager] nearbyServiceBrowser]setDelegate:self];
    
    self.peerIDArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerChangedStateWithNotification:)
                                                 name:@"MCManagerDidChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReceivedDataWithNotification:)
                                                 name:@"MCManagerDidRecieveDataNotification"
                                               object:nil];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peerChangedStateWithNotification:(NSNotification *)notification {
    
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"Session Connected");
            self.testConnectedWithLabel.text = @"Connected";
            break;
        case MCSessionStateConnecting:
            NSLog(@"Session Connecting");
            self.testConnectedWithLabel.text = @"Connecting";

            break;
        case MCSessionStateNotConnected:
            NSLog(@"Session not connected");
            self.testConnectedWithLabel.text = @"Not Connected";

            break;
            
        default:
            break;
    }
}

- (void)handleReceivedDataWithNotification:(NSNotification *)notification {
    
    // Get the user info dictionary that was received along with the notification.
    NSDictionary *userInfoDict = [notification userInfo];
    
    // Convert the received data into a NSString object.
    NSData *receivedData = [userInfoDict objectForKey:@"data"];
    NSString *message = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    self.testConnectedWithLabel.text = message;
    
    // Keep the sender's peerID and get its display name.
//    MCPeerID *senderPeerID = [userInfoDict objectForKey:@"peerID"];
//    NSString *senderDisplayName = senderPeerID.displayName;
    
}

#pragma mark - IBActions
- (IBAction)testP2P:(id)sender {
    [[[MCManager sharedManager]nearbyServiceBrowser] startBrowsingForPeers];
    
}

#pragma mark -  MCNearbyServiceBrowser Delegate


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    [browser invitePeer:peerID toSession:[[MCManager sharedManager]session] withContext:nil timeout:15.0];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

// OPTIONAL
// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {

    
    NSLog(@"ERROR:%@",[error localizedDescription]);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)disconnect:(id)sender {
    
    [[[MCManager sharedManager]session]disconnect];
}

- (IBAction)sendTestData:(UIButton *)sender {
    
    NSString *stringToSend = sender.titleLabel.text;
    
    NSData *dataToSend = [stringToSend dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    [[[MCManager sharedManager] session] sendData:dataToSend toPeers:[[[MCManager sharedManager]session]connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}
@end
