//
//  MCManager.m
//  MilkShake
//
//  Created by Daniel Rakhamimov on 4/14/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "MCManager.h"

NSString *const kServiceType = @"ms-songshare";

typedef void(^InvitationHandler)(BOOL accept, MCSession *session);

@interface MCManager ()<MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, UIAlertViewDelegate>

@property (copy, nonatomic) InvitationHandler handler;

@end

@implementation MCManager

- (id)init {
    
    self = [super init];
    if (self) {
        _peerID = nil;
        _session = nil;
        _nearbyServiceAdvertiser = nil;
        _nearbyServiceBrowser = nil;
    }
    return self;
}

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    
    self.peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    self.session = [[MCSession alloc]initWithPeer:self.peerID
                                 securityIdentity:nil
                             encryptionPreference:MCEncryptionNone];
    
}
- (void)setupMCBrowser {
    
//    self.nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc]
//                                 initWithPeer:self.peerID
//                                 serviceType:k]
    
}
- (void)advertiseSelf:(BOOL)shouldAdvertise {
    
    if (shouldAdvertise) {
        self.nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc]
                                        initWithPeer:self.peerID
                                        discoveryInfo:nil
                                        serviceType:kServiceType];
        self.nearbyServiceAdvertiser.delegate = self;
        [self.nearbyServiceAdvertiser startAdvertisingPeer];
    }
    
}

#pragma mark - MCSession Delegate

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler {
    
    self.handler = invitationHandler;
    
    [[[UIAlertView alloc] initWithTitle:@"Hey! Let's Connect"
                                message:[NSString
                                         stringWithFormat:@"%@ wants to connect",
                                         peerID.displayName] delegate:self
                      cancelButtonTitle:@"Nope"
                      otherButtonTitles:@"Sure", nil] show];
    
}

#pragma mark - MCNearbyServiceBrowserDelegate

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    BOOL accept = (buttonIndex == alertView.cancelButtonIndex) ? NO : YES;
    self.handler(accept, self.session);
}

@end
