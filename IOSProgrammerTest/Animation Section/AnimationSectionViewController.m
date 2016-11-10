//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"



@interface AnimationSectionViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UILabel *hireMeLabel;
@property (nonatomic, strong) UIPushBehavior *push;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *spinView;
@property int rotationCounter;

@end

@implementation AnimationSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //creates label that is used in custom animation
    self.hireMeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 40 , 90, 70)];
    [self.view addSubview:self.hireMeLabel];
    
    //create back button icon from assets
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backButton"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backToHomeScreen:)];
    self.navigationItem.leftBarButtonItem=btn;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //create title
    self.title = @"Animation";
    
    //adds tap gesture to the spin button
    UITapGestureRecognizer *spinTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethodRotate:)];
    [self.spinView addGestureRecognizer:(spinTap)];
    
    //the below code allows the AppPartners logo to be dragged
    self.logoImageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMethod:)];
    [self.logoImageView addGestureRecognizer:panRecognizer];
}

//code to implement the drag feature for the AppPartner logo
-(void) panMethod:(UIPanGestureRecognizer*) sender
{
    CGPoint touchLocation = [sender locationInView: self.view];
    self.logoImageView.center = touchLocation;
}

//this method sends the user back to the main view
-(void)backToHomeScreen: sender
{
    //This next code creates a custom animation for moving from view controllers
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"suckEffect";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//is called when the spin button is pressed
-(void) tapMethodRotate: (UITapGestureRecognizer*) sender
{
    self.rotationCounter = 1;
    [self rotateSpinningView];
}

- (void)rotateSpinningView
{
    //This code rotates the AppPartners logo 90 degrees counterclockwise and is then recursivly called 3 more times to complete the 360 degree rotation.  At the end of the method my custom animation begins.
    [UIView animateWithDuration:.25
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        [self.logoImageView setTransform:CGAffineTransformRotate(self.logoImageView.transform, -M_PI_2)];
                    }
                     completion:^(BOOL finished) {
                         if (finished && !CGAffineTransformEqualToTransform(self.logoImageView.transform, CGAffineTransformIdentity)) {
                             if(self.rotationCounter != 4){
                                 self.rotationCounter++;
                                 [self rotateSpinningView];
                             } else {
                                 [self createHireMe];
                             }
                         }
                     }];
}

//this method uses the UIDynamicAnimator to bounce the "Hire Me" label around the view
-(void) createHireMe
{
    self.hireMeLabel.font = [UIFont fontWithName:@"Machinato-Light" size:20.0];
    self.hireMeLabel.text = @"Hire Me";
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    UIDynamicItemBehavior *bouncingBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.hireMeLabel]];
    bouncingBehavior.elasticity = 1;
    bouncingBehavior.friction = 0;
    bouncingBehavior.allowsRotation = YES;
    bouncingBehavior.resistance = 0;
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.hireMeLabel]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.push = [[UIPushBehavior alloc] initWithItems:@[self.hireMeLabel]
                                                 mode:UIPushBehaviorModeInstantaneous];
    self.push.pushDirection = CGVectorMake(0.5, 1.0);
    self.push.active = YES;
    self.push.magnitude = 2;
    [self.animator addBehavior:bouncingBehavior];
    [self.animator addBehavior:collisionBehavior];
    [self.animator addBehavior:self.push];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
