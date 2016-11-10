//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"
//macro used to create a UIColor from hexidecimal
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ChatCell ()

@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatText;

@end

@implementation ChatCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatarImageView.layer.cornerRadius = 20;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.textColor = UIColorFromRGB(0x252525);
    self.usernameLabel.text = chatData.username;
    self.chatText.text = chatData.message;
}


@end
