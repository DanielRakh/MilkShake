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

@interface MCManager ()<MCNearbyServiceAdvertiserDelegate,  UIAlertViewDelegate>

@property (copy, nonatomic) InvitationHandler handler;

@end

@implementation MCManager


+ (id)sharedManager {
    static MCManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
    
}

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

- (void)setupPeerWithDisplayName:(NSString *)displayName {
    
    self.peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    
}



- (void)setupSession {
    
    self.session = [[MCSession alloc]initWithPeer:self.peerID];
    self.session.delegate = self;
}


- (void)setupBrowser {
    
    self.nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc]
                                 initWithPeer:self.peerID
                                 serviceType:kServiceType];
    
}
- (void)advertiseSelf:(BOOL)shouldAdvertise {
    
    if (shouldAdvertise) {
        self.nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc]
                                        initWithPeer:self.peerID
                                        discoveryInfo:nil
                                        serviceType:kServiceType];
        self.nearbyServiceAdvertiser.delegate = self;
        [self.nearbyServiceAdvertiser startAdvertisingPeer];
    } else {
        [self.nearbyServiceAdvertiser stopAdvertisingPeer];
        self.nearbyServiceAdvertiser = nil;
    }
    
}

#pragma mark - MCSession Delegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSDictionary *userInfo = @{ @"peerID": peerID,
                                @"state" : @(state) };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCManagerDidChangeStateNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
    
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSDictionary *userInfo = @{ @"data": data,
                                @"peerID": peerID };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MCManagerDidRecieveDataNotification"
                                                            object:nil
                                                          userInfo:userInfo];
    });
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
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



#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    BOOL accept = (buttonIndex == alertView.cancelButtonIndex) ? NO : YES;
    self.handler(accept, self.session);
}

@end
