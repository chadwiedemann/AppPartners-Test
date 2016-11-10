//
//  NavAlphaChange.m
//  IOSProgrammerTest
//
//  Created by Chad Wiedemann on 11/7/16.
//  Copyright © 2016 AppPartner. All rights reserved.
//

#import "NavAlphaChange.h"
#import <QuartzCore/QuartzCore.h>

@implementation NavAlphaChange

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
