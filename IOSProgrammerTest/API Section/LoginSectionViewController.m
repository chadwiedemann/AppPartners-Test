//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController ()

@property (nonatomic, strong) NSDictionary *responseDictionary;
@property (nonatomic, strong) NSDate *beginningOfPOST;
@property (nonatomic, strong) NSDate *endOfPOST;
@property long lengthOfPOSTinMiliseconds;
@property BOOL loginSuccessful;

@end

@implementation LoginSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlert)
                                                 name:@"alertTime"
                                               object:nil];
    
    //creates the back button on the navigation bar
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backButton"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHomeScreen:)];
    self.navigationItem.leftBarButtonItem=btn;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //create title on the navbar
    self.title = @"Login";
    
    //add tap gesture recognizer to view to login
    UITapGestureRecognizer *loginTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethodLogin:)];
    [self.loginView addGestureRecognizer:(loginTap)];
}

-(void)backToHomeScreen: sender
{
    //This next code creates a custom animation for moving from view controllers
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//This method sends the POST request to the AppPartners server
-(void) tapMethodLogin: (UITapGestureRecognizer*) sender
{
    NSDictionary *dictionary = [self createLoginDictionary];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://dev3.apppartner.com/AppPartnerDeveloperTest/scripts/login.php"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self httpBodyForParamsDictionary:dictionary]];
    self.beginningOfPOST = [NSDate date];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            self.endOfPOST = [NSDate date];
            self.lengthOfPOSTinMiliseconds = lround([self.endOfPOST timeIntervalSinceDate:self.beginningOfPOST]*1000);
            NSString *putInString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *JSONData = [putInString dataUsingEncoding:NSUTF8StringEncoding];
            NSError* error2;
            self.responseDictionary = [NSJSONSerialization JSONObjectWithData: JSONData options:NSJSONReadingMutableContainers error:&error2];
            if([[self.responseDictionary objectForKey:@"code"] isEqualToString:@"Success"]){
                self.loginSuccessful = YES;
            }else self.loginSuccessful = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"alertTime"
                 object:nil];
            });
            
        }else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    [dataTask resume];
}

//this creates the dictionary with the user input from the text fields
-(NSDictionary*) createLoginDictionary
{
    NSDictionary *postDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:self.usernameTextField.text, @"username", self.passwordTextField.text, @"password", nil];
    return postDictionary;
}

//this code is used in the POST request to create the parameters to send
- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

//this is used in the previous method to format the string to create the data to send the paramaters
- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

//This method creates the alert following the user's login attempt
-(void)showAlert
{
    NSString *code = [NSString stringWithFormat:@"%@", [self.responseDictionary valueForKey:@"code"]];
    NSString *message = [NSString stringWithFormat:@"%@", [self.responseDictionary valueForKey:@"message"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Attempt" message:[NSString stringWithFormat: @"%@\n%@\nYour POST request took %ld miliseconds",code,message,self.lengthOfPOSTinMiliseconds] preferredStyle:UIAlertControllerStyleAlert];
    
    //the completion handler will send the user back to the home screen if they logged in successfully
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){ if(self.loginSuccessful){
        //This next code creates a custom animation for moving from view controllers
        CATransition* transition = [CATransition animation];
        transition.duration = .5;
        transition.type = @"pageCurl";
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
