//
//  TopViewController.h
//  LoveTwiLive
//
//  Created by 藍口康希 on 2014/08/12.
//  Copyright (c) 2014年 mrt. All rights reserved.
//


#define kOAUTH_TOK    @"*********************"
#define kOAUTH_SEC    @"*********************"

#import <UIKit/UIKit.h>
#import "STTwitter.h"

@interface TopViewController : UIViewController{
    NSMutableArray *postsArray;
    STTwitterAPI   *twitterAPIClient;
    
}

-(void)getAccessToken;
- (void)loginTwitter;
- (void)getTimeline;
@property (nonatomic,strong)NSString *accessToken;
@property (nonatomic,strong)NSString *accessTokenSecret;

@end
