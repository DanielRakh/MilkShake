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
    
}
- (void)setupMCBrowser {
    
}
- (void)advertiseSelf:(BOOL)shouldAdvertise {
    
}

@end
