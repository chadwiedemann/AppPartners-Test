//
//  TableSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatSectionViewController.h"
#import "MainMenuViewController.h"
#import "ChatCell.h"

@interface ChatSectionViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *loadedChatData;
@property int downloadCounter;

@end

@implementation ChatSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.employees = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"photosDownloaded"
                                               object:nil];
    //create back button icon from assets
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backButton"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(backToHomeScreen:)];
    self.navigationItem.leftBarButtonItem=btn;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    //create title
    self.title = @"Chat";
    //remove header from table view
    self.tableView.tableHeaderView = nil;
    //make cells flexible to fit entire comment
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
    self.loadedChatData = [[NSMutableArray alloc] init];
    [self loadJSONData];
}

-(void)reloadData
{
    [self.tableView reloadData];
}

//this method loads the JSON data from file and creates an employee array from their unique employee IDs
- (void)loadJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatData" ofType:@"json"];
    NSError *error = nil;
    NSData *rawData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    id JSONData = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&error];
    [self.loadedChatData removeAllObjects];
    if ([JSONData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonDict = (NSDictionary *)JSONData;
        NSArray *loadedArray = [jsonDict objectForKey:@"data"];
        if ([loadedArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *chatDict in loadedArray)
            {
                ChatData *chatData = [[ChatData alloc] init];
                [chatData loadWithDictionary:chatDict];
                [self.loadedChatData addObject:chatData];
            }
        }
    }
    
    //create employee array
    for(ChatData *data in self.loadedChatData){
        if(self.employees.count == 0){
        AppPartnerEmployee *tempEmployee = [[AppPartnerEmployee alloc]initWithEmployeeID:data.user_id picURL:data.avatar_url];
            [self.employees addObject:tempEmployee];
        }
        bool exists = NO;
        for(int i = 0; i<self.employees.count; i++){
            if(data.user_id == [self.employees[i] user_id]){
                exists = YES;
            }
        }
        if(!exists){
            AppPartnerEmployee *tempEmployee = [[AppPartnerEmployee alloc]initWithEmployeeID:data.user_id picURL:data.avatar_url];
            [self.employees addObject:tempEmployee];
        }
    }
    [self downloadPictures];
    [self.tableView reloadData];
}

//this method downloads all the pictures for the employees and adds them to the employee objects found in the employee array
-(void)downloadPictures
{
    self.downloadCounter = 0;
    for(AppPartnerEmployee *employee in self.employees){
        NSURL *url = [NSURL URLWithString:employee.picURL];
        NSURLSessionDownloadTask *downLoadPhotoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error){
                UIImage *downLoadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                employee.employeePic = downLoadedImage;
                self.downloadCounter++;
                if(self.employees.count == self.downloadCounter)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"photosDownloaded"
                         object:nil];
                    });}else{
                    NSLog(@"%@",error.localizedDescription);
                }
        }];
        [downLoadPhotoTask resume];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)backToHomeScreen: sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = .5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatCell";
    ChatCell *cell = nil;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ChatCell *)[nib objectAtIndex:0];
    }
    ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];
    [cell loadWithData:chatData];
    
    for (AppPartnerEmployee *emp in self.employees) {
        if (chatData.user_id == emp.user_id) {
            cell.avatarImageView.image = emp.employeePic;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadedChatData.count;
}

@end
