//
//  AppPartnerEmployee.m
//  IOSProgrammerTest
//
//  Created by Chad Wiedemann on 11/8/16.
//  Copyright © 2016 AppPartner. All rights reserved.
//

#import "AppPartnerEmployee.h"

@implementation AppPartnerEmployee

-(instancetype)initWithEmployeeID: (int) employeeID picURL: (NSString *) URL
{
    self = [super init];
    if(self)
    {
        _user_id = employeeID;
        _picURL = URL;
    }
    return self;
}

@end
