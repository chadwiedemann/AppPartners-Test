//
//  ViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ChatSectionViewController.h"
#import "LoginSectionViewController.h"
#import "AnimationSectionViewController.h"

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *animationTestView;

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //table view tap
    UITapGestureRecognizer *tableViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethodChat:)];
    [self.chatView addGestureRecognizer:(tableViewTap)];
    
    //login screen tap
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethodLogin:)];
    [self.loginView addGestureRecognizer:(loginTap)];
    
    //animation test tap
    UITapGestureRecognizer *animationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethodAnimation:)];
    [self.animationTestView addGestureRecognizer:(animationTap)];
    
    //Create title for view
    self.title = @"Coding Tasks";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//move to Chat view controller
-(void) tapMethodChat: (UITapGestureRecognizer*) sender
{
    ChatSectionViewController *tableSectionViewController = [[ChatSectionViewController alloc] init];
    
    //This next code creates a custom animation for moving from view controllers
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:tableSectionViewController animated:YES];
}

//move to Login view controller
-(void) tapMethodLogin: (UITapGestureRecognizer*) sender
{
    //This next code creates a custom animation for moving from view controllers
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    LoginSectionViewController *apiSectionViewController = [[LoginSectionViewController alloc] init];
    [self.navigationController pushViewController:apiSectionViewController animated:YES];
}

//move to Animation Test view controller
-(void) tapMethodAnimation: (UITapGestureRecognizer*) sender
{
    //This next code creates a custom animation for moving from view controllers
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"suckEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    AnimationSectionViewController *animationSectionViewController = [[AnimationSectionViewController alloc] init];
    [self.navigationController pushViewController:animationSectionViewController animated:YES];
}

@end
