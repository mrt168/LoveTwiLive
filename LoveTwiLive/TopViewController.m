//
//  TopViewController.m
//  LoveTwiLive
//
//  Created by 藍口康希 on 2014/08/12.
//  Copyright (c) 2014年 mrt. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    CGFloat iPhone5headSpace = 0;
    if (self.view.bounds.size.height > 480) {
        iPhone5headSpace = 28;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    UILabel *logoLabel = [[UILabel alloc]init];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.font = [UIFont boldSystemFontOfSize:36];
    logoLabel.text = @"ひよこゲーム";
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.frame = CGRectMake(20, 20, 280, 40);
    [self.view addSubview:logoLabel];
    
    UIImageView *logoImv = [[UIImageView alloc]init];
    logoImv.image = [UIImage imageNamed:@"hiyo.png"];
    logoImv.frame = CGRectMake(100, 80 + iPhone5headSpace, 120, 120);
    [self.view addSubview:logoImv];
    
    [self getAccessToken];
}

-(void)makeTableView
{
    twitterTable = [[UITableView alloc]init];
    // テーブルビュー例文
    twitterTable.frame = CGRectMake(0, 20, 320, 568);
    twitterTable.delegate = self;
    twitterTable.dataSource = self;
    
    [self.view addSubview:twitterTable];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return postsArray.count;
}

-(CGFloat)tableView:
(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 対象インデックスのステータス情報を取り出す
    NSDictionary *status = [postsArray objectAtIndex:indexPath.row];
    for(id keys in[status allKeys]){
        NSLog(@"status %@",keys);
    }
    // ツイート本文をもとにセルの高さを決定
    //sizeWithFont:[UIFont systemFontOfSize:12]
    NSString *content = [status objectForKey:@"text"];
    
    //ios6まで
    /*
     CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:12]
     constrainedToSize:CGSizeMake(300, 1000)
     lineBreakMode:NSLineBreakByWordWrapping];
     */
    
    //ios7から
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(300, 1000)
                                             options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    return labelSize.height + 50;
}

-(UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    // 対象インデックスのステータス情報を取り出す
    
    NSDictionary *status = [postsArray objectAtIndex:indexPath.row];
    
    // ツイート本文をもとにセルの高さを決定
    //sizeWithFont:[UIFont systemFontOfSize:12]
    
    NSString *content = [status objectForKey:@"text"];
    NSString *userName = [status valueForKeyPath:@"user.name"];
    NSString *userScreenName = [status valueForKeyPath:@"user.screen_name"];//status[@"user"][@"name"];
    CGSize labelSize = [userName boundingRectWithSize:CGSizeMake(300, 1000)
                                              options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    
    
    [cell addSubview:[self makeCellLabel:userName textColor:[UIColor redColor] frame:CGRectMake(0, 0, labelSize.width, 20) fontSize:[UIFont systemFontOfSize:14]] ];
    [cell addSubview:[self makeCellLabel:[NSString stringWithFormat:@"@%@",userScreenName] textColor:[UIColor blueColor] frame:CGRectMake(labelSize.width+10, 0, 320-labelSize.width-10, 20) fontSize:[UIFont systemFontOfSize:13]]];
    cell.textLabel.center = CGPointMake(0, labelSize.height+5);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = content;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 0;
    NSLog(@"content:%@ status: %@ count: %d",content,status,postsArray.count);
    return cell;
}

-(UILabel *) makeCellLabel:(NSString *)text
                 textColor:(UIColor *)color
                     frame:(CGRect)frame
                  fontSize:(UIFont*)fontSize
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = color;
    label.frame = frame;
    label.font = fontSize;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

-(void)yahoo
{
    [twitterAPIClient verifyCredentialsWithSuccessBlock:^(NSString *username) {
        NSLog(@"-- Account: %@", username);
        
        [twitterAPIClient postStatusesFilterUserIDs:nil
                                    keywordsToTrack:@[@"Apple"]
                              locationBoundingBoxes:nil
                                          delimited:nil
                                      stallWarnings:nil
                                      progressBlock:^(id response) {
                                          
                                          if ([response isKindOfClass:[NSDictionary class]] == NO) {
                                              NSLog(@"Invalid tweet (class %@): %@", [response class], response);
                                              exit(1);
                                              return;
                                          }
                                          postsArray = [[NSMutableArray alloc] init];
                                          [postsArray addObjectsFromArray:response];
                                          twitterDictionary = response;
                                          NSLog(@"array : %@\n", twitterDictionary);
                                          printf("-----------------------------------------------------------------\n");
                                          printf("-- user: @%s\n", [[response valueForKeyPath:@"user.screen_name"] cStringUsingEncoding:NSUTF8StringEncoding]);
                                          printf("-- text: %s\n", [[response objectForKey:@"text"] cStringUsingEncoding:NSUTF8StringEncoding]);
                                          
                                          //                                 [self makeTableView];
                                          
                                      } stallWarningBlock:nil errorBlock:^(NSError *error) {
                                          NSLog(@"Stream error: %@", error);
                                          exit(1);
                                      }];
        
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- %@", [error localizedDescription]);
        exit(1);
    }];
}

-(void)tableView:
(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *status = [postsArray objectAtIndex:indexPath.row];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    [self getUserTimeLine: screenName];
}



-(void)getAccessToken
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                              consumerKey:@"CxnjlewJuQPvPFSY7ZaKGSuBG"
                                                           consumerSecret:@"UOuqbVIfadvOVZbMUkxXrTnsvef3633NwvICHrNwjD2xK8uRA3"];
    [twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        
        STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithFirstAccount];
        
        [twitterAPIOS verifyCredentialsWithSuccessBlock:^(NSString *username) {
            
            [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                successBlock:^(NSString *oAuthToken,
                                                                               NSString *oAuthTokenSecret,
                                                                               NSString *userID,
                                                                               NSString *screenName) {
                                                                    self.accessToken = oAuthToken;
                                                                    self.accessTokenSecret = oAuthTokenSecret;
                                                                    NSLog(@"Token %@ secret %@",oAuthToken,oAuthTokenSecret);
                                                                    [self loginTwitter];
                                                                } errorBlock:^(NSError *error) {
                                                                    NSLog(@"error %@",[error description]);
                                                                    
                                                                }];
            
        } errorBlock:^(NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
    
}

-(void)loginTwitter
{
    twitterAPIClient = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                         consumerKey:kCONSUMER_KEY
                                                      consumerSecret:kCONSUMER_SEC
                                                          oauthToken:self.accessToken
                                                    oauthTokenSecret:self.accessTokenSecret];
    [twitterAPIClient getAccountVerifyCredentialsWithSuccessBlock:^(NSDictionary *account) {
        // ログイン成功
        for(id keys in[account allKeys]){
            NSLog(@"%@",keys);
        }
        NSLog(@"granted");
        //        [self yahoo];
//        [self getTimeline];
//        [self getUserTimeLine:@"kamira69"];
//                [self getUserStream];
        [self searchText:@"LoveLive"];
    } errorBlock:^(NSError *error) {
        // ログイン失敗
        NSLog(@"error : %@", error);
        
        
    }];
}

- (void)getTimeline
{
    [twitterAPIClient getHomeTimelineSinceID:nil
                                       count:100
                                successBlock:^(NSArray *statuses) {
                                    // 取得成功
                                    NSLog(@"Loaded data");
                                    NSLog(@"array : %@\n", statuses);
                                    postsArray = [[NSMutableArray alloc] init];
                                    [postsArray addObjectsFromArray:statuses];
                                    NSLog(@"array : %@\n", postsArray);
                                    
                                    [self makeTableView];
                                } errorBlock:^(NSError *error) {
                                    // 取得失敗
                                    NSLog(@"Error : %@", error);
                                }];
}

- (void)getUserTimeLine:(NSString *)text
{
 NSLog(@"search :%@ ",text);
    [twitterAPIClient getUserTimelineWithScreenName:text
                              successBlock:^(NSArray *statuses) {
                                  // ...
                                  NSLog(@"Loaded data");
                                  NSLog(@"array : %@\n", statuses);
                                  postsArray = [[NSMutableArray alloc] init];
                                  [postsArray addObjectsFromArray:statuses];
                                  NSLog(@"array : %@\n", postsArray);
                                  [twitterTable reloadData];
                                  //一番上
                                  [twitterTable setContentOffset:CGPointZero animated:YES];
                                  
                              } errorBlock:^(NSError *error) {
                                  // ...
                              }];
    
}




-(void)getUserStream
{
    [twitterAPIClient getUserStreamDelimited:nil
                               stallWarnings:nil
         includeMessagesFromFollowedAccounts:nil
                              includeReplies:nil
                             keywordsToTrack:nil
                       locationBoundingBoxes:nil
                               progressBlock:^(id response) {
                                   // 取得成功
                                   NSLog(@"progress");
                                   postsArray = [[NSMutableArray alloc] init];
                                   [postsArray addObject:response];
                                   NSLog(@"array : %@\n", postsArray);
                                   
                               } stallWarningBlock:^(NSString *code, NSString *message, NSUInteger percentFull) {
                                   NSLog(@"stall");
                                   
                               } errorBlock:^(NSError *error) {
                                   NSLog(@"error");
                               }];
}

-(void)searchText:(NSString *)queryWord
{
    [twitterAPIClient getSearchTweetsWithQuery:queryWord
                                  successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                      // 取得成功
                                      // ログイン成功
                                      for(id keys in[searchMetadata allKeys]){
                                          NSLog(@"search %@",keys);
                                      }
                                      NSLog(@"progress");
                                      postsArray = [[NSMutableArray alloc] init];
                                      [postsArray addObjectsFromArray:statuses];
                                      [self makeTableView];
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"error");
                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
