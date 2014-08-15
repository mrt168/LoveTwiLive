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

@interface TopViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *postsArray;
    NSDictionary *twitterDictionary;
    STTwitterAPI   *twitterAPIClient;
    UITableView *twitterTable;
}

-(void)getAccessToken;
- (void)loginTwitter;
- (void)getTimeline;
- (void)makeTableView;
- (UILabel *)makeCellLabel;
@property (nonatomic,strong)NSString *accessToken;
@property (nonatomic,strong)NSString *accessTokenSecret;

@end