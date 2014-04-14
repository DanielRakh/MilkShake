//
//  MCManager.m
//  MilkShake
//
//  Created by Daniel Rakhamimov on 4/14/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "MCManager.h"

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
    
}
- (void)advertiseSelf:(BOOL)shouldAdvertise {
    
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

@end
