//
//  DocTalkHomeViewController.m
//  docTalkTask
//
//  Created by Iraniya Naynesh on 06/01/18.
//  Copyright © 2018 iraniya. All rights reserved.
//

#import "DocTalkHomeViewController.h"
#import "DocTalkSingleUserTableViewCell.h"
#import "NSRUtilities.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface DocTalkHomeViewController ()<UITextFieldDelegate, UITableViewDataSource, UITabBarDelegate>


//IBoutlet

@property (weak, nonatomic) IBOutlet UITextField *userSearchTextField;
@property (weak, nonatomic) IBOutlet UITableView *userListDisplayTableView;
@property (weak, nonatomic) IBOutlet UILabel *noDataFoundLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicater;

@property (strong, nonatomic) NSArray *userList;
@property (strong, nonatomic) NSString *userName;

@end

@implementation DocTalkHomeViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.loadingActivityIndicater setHidden:YES];
    [self.userListDisplayTableView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API Call

- (void)apiCallForSearchUser:(NSString*)userName {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *apiString = @"https://api.github.com/search/users?q={userName}&sort=followers";
    
    apiString = [apiString stringByReplacingOccurrencesOfString:@"{userName}" withString:userName];
    
    [request setURL:[NSURL URLWithString:apiString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __weak typeof(self) weakSelf = self;
    [self.loadingActivityIndicater setHidden:NO];
    [self.loadingActivityIndicater startAnimating];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Request reply: %@", requestReply);
        
        NSMutableDictionary *dict= [NSJSONSerialization JSONObjectWithData:[requestReply dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        
        NSMutableArray *dataArr=[dict valueForKey:@"items"];
       
        if ([dataArr count]>0) {
            weakSelf.userList = [[NSArray alloc]initWithArray:dataArr];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.loadingActivityIndicater stopAnimating];
            [weakSelf.loadingActivityIndicater setHidden:YES];
            
            if ([weakSelf.userList count] > 0) {
                [weakSelf.noDataFoundLabel setHidden:YES];
                [weakSelf.userListDisplayTableView setHidden:NO];
                [weakSelf.userListDisplayTableView reloadData];
            }
            else {
                [weakSelf.userListDisplayTableView setHidden:YES];
                [weakSelf.noDataFoundLabel setHidden:NO];
            }
        });
        
    }] resume];
}


#pragma mark - UITable View delegate


#pragma mark - TableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    if ([self.userList count] > 0) {
    
        numberOfRows = [self.userList count];
    }
    
    return numberOfRows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    DocTalkSingleUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DocTalkSingleUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *singleUser = [[NSDictionary alloc]initWithDictionary:[self.userList objectAtIndex:indexPath.row]];
    
    cell.userUrl.text = [NSString stringWithFormat:@"%@",[singleUser objectForKey:@"html_url"]];
    
    
    NSString* userAvatar = [NSString stringWithFormat:@"%@",[singleUser objectForKey:@"avatar_url"]];
    
    if ([NSRUtilities isNilOREmptyString:userAvatar] == NO) {
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:userAvatar] placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageContinueInBackground];
    }
    
    NSString *userScore = [NSString stringWithFormat:@"%@",[singleUser objectForKey:@"score"]];
    cell.scoreLabel.text = userScore;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.userSearchTextField resignFirstResponder];
}


#pragma mark - textFied Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([NSRUtilities isNilOREmptyString:newString] == NO) {
         [self apiCallForSearchUser:newString];
    }
    else {
        [self.userListDisplayTableView setHidden:YES];
        [self.noDataFoundLabel setHidden:NO];
    }
    
   return YES;
}


@end
