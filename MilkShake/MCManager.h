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

+ (id)sharedManager;
- (void)setupPeerWithDisplayName:(NSString *)displayName;
- (void)setupSession;
- (void)setupBrowser;
- (void)advertiseSelf:(BOOL)shouldAdvertise;





@end
