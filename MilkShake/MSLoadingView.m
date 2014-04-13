//
//  MSLoadingView.m
//  MilkShake
//
//  Created by David Weissler on 4/13/14.
//  Copyright (c) 2014 Daniel Rakhamimov. All rights reserved.
//

#import "MSLoadingView.h"

@implementation MSLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setBackgroundColor:[UIColor blueColor]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
