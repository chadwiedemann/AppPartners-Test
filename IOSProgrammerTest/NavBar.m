//
//  NavBar.m
//  IOSProgrammerTest
//
//  Created by Chad Wiedemann on 11/7/16.
//  Copyright © 2016 AppPartner. All rights reserved.
//

#import "NavBar.h"

@implementation NavBar

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize s = [super sizeThatFits:size];
    s.height = 44;
    return s;
}


@end
