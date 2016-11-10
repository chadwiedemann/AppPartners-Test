//
//  AppPartnerEmployee.h
//  IOSProgrammerTest
//
//  Created by Chad Wiedemann on 11/8/16.
//  Copyright © 2016 AppPartner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppPartnerEmployee : NSObject

@property (nonatomic, readwrite) int user_id;
@property (nonatomic, strong) UIImage *employeePic;
@property (nonatomic, strong) NSString *picURL;

-(instancetype)initWithEmployeeID: (int) employeeID picURL: (NSString *) URL;

@end
