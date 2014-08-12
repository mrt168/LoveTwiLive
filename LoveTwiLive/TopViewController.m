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
    [twitterAPIClient verifyCredentialsWithSuccessBlock:^(NSString *username) {
        // ログイン成功
        NSLog(@"granted");
        [self getTimeline];
        //[self getUserStream];
    } errorBlock:^(NSError *error) {
        // ログイン失敗
        NSLog(@"error : %@", error);
    }];
}

- (void)getTimeline
{
    [twitterAPIClient getHomeTimelineSinceID:nil
                                       count:20
                                successBlock:^(NSArray *statuses) {
                                    // 取得成功
                                    NSLog(@"Loaded data");
                                    NSLog(@"array : %@\n", statuses);
                                    [postsArray addObjectsFromArray:statuses];
                                } errorBlock:^(NSError *error) {
                                    // 取得失敗
                                    NSLog(@"Error : %@", error);
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
