//
//  SecondViewController.m
//  MilkShake
//
//  Created by Daniel Rakhamimov on 4/14/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "SecondViewController.h"
#import "MCManager.h"

@interface SecondViewController () <MCNearbyServiceBrowserDelegate, MCSessionDelegate>
@property (nonatomic, strong) MCManager *mcManager;
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
    
    self.mcManager = [MCManager sharedManager];
    [self.mcManager setupBrowser];
    self.mcManager.nearbyServiceBrowser.delegate = self;
    self.mcManager.session.delegate = self;
    
    self.peerIDArray = [NSMutableArray array];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)testP2P:(id)sender {
    [self.mcManager.nearbyServiceBrowser startBrowsingForPeers];
    
}

#pragma mark -  MCNearbyServiceBrowser Delegate


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    [browser invitePeer:peerID toSession:self.mcManager.session withContext:nil timeout:15.0];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

// OPTIONAL
// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {

    
    NSLog(@"ERROR:%@",[error localizedDescription]);
}


#pragma mark - MCSession Delegate Methods


// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    switch (state) {
        case MCSessionStateConnected:
            NSLog(@"Session Connected");
            [self.peerIDArray addObject:peerID];
            break;
        case MCSessionStateConnecting:
            NSLog(@"Session Connecting");
            break;
        case MCSessionStateNotConnected:
            NSLog(@"Session not connected");
            break;
            
        default:
            break;
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSString *stringRecieved = [NSString stringWithUTF8String:[data bytes]];
    self.testConnectedWithLabel.text = stringRecieved;
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

- (IBAction)sendTestData:(UIButton *)sender {
    
    NSString *stringToSend = sender.titleLabel.text;
    
    NSData *dataToSend = [stringToSend dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    [self.mcManager.session sendData:dataToSend toPeers:@[self.peerIDArray] withMode:MCSessionSendDataReliable error:&error];
}
@end
