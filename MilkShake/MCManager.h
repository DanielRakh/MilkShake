//
//  MCManager.h
//  MilkShake
//
//  Created by Daniel Rakhamimov on 4/14/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

@interface MCManager : NSObject <MCSessionDelegate>
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *nearbyServiceBrowser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *nearbyServiceAdvertiser;

- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
- (void)setupMCBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;





@end
