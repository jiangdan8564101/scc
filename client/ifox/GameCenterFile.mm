//
//  GameConfigLoader.m
//  ixyhz
//
//  Created by fox1 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameCenterFile.h"
#import "cocos2d.h"

extern UIWindow* gAppWindows;

@implementation GameKitHelper

@synthesize gameAccountChanged;
@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize accountID;
//静态初始化 对外接口
static GameKitHelper *sharedHelper = nil;
static UIViewController* currentModalViewController = nil;
+ (GameKitHelper *) sharedGameKitHelper {
    if (!sharedHelper) {
        sharedHelper = [[GameKitHelper alloc] init];
    }
    return sharedHelper;
}
//用于验证
- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer =@"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
//            NSNotificationCenter *nc =
//            [NSNotificationCenter defaultCenter];
//            [nc addObserver:self
//                   selector:@selector(authenticationChanged)
//                       name:GKPlayerAuthenticationDidChangeNotificationName
//                     object:nil];
            if ( [GKLocalPlayer localPlayer].isAuthenticated )
            {
                
            }
            else
            {
                //[ self registerNewAccount ];
            };
        }
    }
    return self;
}

- (void) registerNewAccount
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
    //记录当前注册的game center 用户
    accountID = [GKLocalPlayer localPlayer].playerID;
}
//后台回调登陆验证
- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated &&!userAuthenticated) {
        //NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        //NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
        //[ GKNotificationBanner showBannerWithTitle:@"Warning!" message:@"Your account is unauthenticationed!" completionHandler:nil ];
    }
    
}


//friends
- (void) retrieveFriends
{
    GKLocalPlayer *lp = [GKLocalPlayer localPlayer];
    if (lp.authenticated)
    {
        [lp loadFriendsWithCompletionHandler:^(NSArray *friends, NSError *error) {
            if (friends != nil)
            {
                [self loadPlayerData: friends];
            }
        }];
    }
}
//Retrieving player details
- (void) loadPlayerData: (NSArray *) identifiers
{
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error)
    {
        if (error != nil)
        {
            // Handle the error.
            
        }
        if (players != nil)
        {
            // Process the array of GKPlayer objects.
        }
    }];
}

- (void)authenticateLocalUser {
    
    if (!gameCenterAvailable) return;
    
    //NSLog(@"Authenticating local user...");
    
    if ([GKLocalPlayer localPlayer].authenticated == NO)
    {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
        {
            if (error == nil)
            {
                //[ self reportAchievementIdentifier:@"a0" percentComplete:100 ];
                //[ self reportScore:90000 forCategory:@"points" ];
                //[ self showLeaderboard ];
                //[ self showGameCenter ];
                //[ self showAchievements ];
                if( accountID && accountID != [GKLocalPlayer localPlayer].playerID)
                {
                    //[ GKNotificationBanner showBannerWithTitle:@"Attention!" message:@"Your account is changed!" completionHandler:nil ];
                }
            }
            else
            {
                
            }
        }];
    }
    else
    {
        //NSLog(@"Already authenticated!");
    }
}


-  (void) retrieveScores
{
//    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
//    
//    if (leaderboardRequest != nil)
//    {
//        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
//        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
//        leaderboardRequest.range = NSMakeRange(1,10);
//        leaderboardRequest.category = @"TS_LB";
//        
//        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
//            if (error != nil)
//            {
//                NSLog(@"下载失败");
//            }
//            
//            if ( scores != nil )
//            {
//                 NSArray *tempScore = [NSArray arrayWithArray:leaderboardRequest.scores];
//                for (GKScore *obj in tempScore) {
//                    
//                }
//            }
//    }
}


- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error)
     {
         
     }
     ];
}

//显示排行榜
- (void) showLeaderboard
{
    if (!gameCenterAvailable || currentModalViewController) return;
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
        
        currentModalViewController = [[UIViewController alloc] init];
        [ gAppWindows addSubview:currentModalViewController.view];
        [currentModalViewController presentModalViewController:leaderboardController animated:YES];
    }
    
}
//关闭排行榜回调
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController{
    if(currentModalViewController !=nil){
        [currentModalViewController dismissModalViewControllerAnimated:NO];
        [currentModalViewController.view removeFromSuperview];
        [currentModalViewController release];
        currentModalViewController = nil;
    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{

}

- (void) showMachView
{
    if (!gameCenterAvailable || currentModalViewController) return;
    GKMatchmakerViewController* matchshow = [[ GKMatchmakerViewController alloc] init];
    if(matchshow != nil)
    {
        matchshow.matchmakerDelegate = self;
  
        currentModalViewController = [[UIViewController alloc] init];
        [ gAppWindows addSubview:currentModalViewController.view];
        [ currentModalViewController presentViewController: matchshow animated: YES
                                               completion:nil];
    }
    
}
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [currentModalViewController dismissModalViewControllerAnimated:YES];
    [currentModalViewController release];
    [currentModalViewController.view removeFromSuperview];
    currentModalViewController = nil;
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [currentModalViewController dismissModalViewControllerAnimated:YES];
    [currentModalViewController release];
    [currentModalViewController.view removeFromSuperview];
    currentModalViewController = nil;
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
//    AppController *app = (AppController*) [[UIApplicatiosharedApplication] delegate];
//    [[app navController] dismissModalViewControllerAnimated:YES];
    
    [currentModalViewController dismissModalViewControllerAnimated:YES];
    [currentModalViewController release];
    [currentModalViewController.view removeFromSuperview];
    currentModalViewController = nil;
}

//report a achievement
- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    if ( percent == 100.0f )
    {
//        AchievementConfig* config = GameAchievementConfig::Instance()->GetData( [ identifier UTF8String ] );
//        
//        NSString* str1 = [ NSString stringWithUTF8String:config->name.c_str() ];
//        NSString* str = [ NSString stringWithFormat:@"达成成就%@" , str1 ];
//        
//        [ GKNotificationBanner showBannerWithTitle:@"恭喜！" message:str completionHandler:nil ];
    }
    
    
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 //The proper way for your application to handle network errors is retain
                 //the achievement object (possibly adding it to an array). Then, periodically
                 //attempt to report the progress until it is successfully reported.
                 //The GKAchievement class supports the NSCoding protocol to allow your
                 //application to archive an achie
                 //NSLog(@"报告成就进度失败 ,错误信息为: \n %@",error);
             }
             else
             {
                 
                 
                 //对用户提示,已经完成XX%进度
                 //NSLog(@"报告成就进度---->成功!");
//                 NSLog(@"    completed:%d",achievement.completed);
//                 NSLog(@"    hidden:%d",achievement.hidden);
//                 NSLog(@"    lastReportedDate:%@",achievement.lastReportedDate);
//                 NSLog(@"    percentComplete:%f",achievement.percentComplete);
//                 NSLog(@"    identifier:%@",achievement.identifier);
             }
         }];
    }
}

- (void) showAchievements
{
    if (!gameCenterAvailable || currentModalViewController) return;
    
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    
    //GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (achievements != nil)
    {
        achievements.achievementDelegate = self;
        achievements.viewState = GKGameCenterViewControllerStateAchievements;
        
        currentModalViewController = [[UIViewController alloc] init];
        [ gAppWindows addSubview:currentModalViewController.view];
        [ currentModalViewController presentViewController: achievements animated: YES
                         completion:nil];
    }
    [achievements release];
}

- (void)showGameCenter
{
    [[GameKitHelper sharedGameKitHelper] authenticateLocalUser];
    if( !gameCenterAvailable || currentModalViewController ) return;
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if(gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        
        currentModalViewController = [[UIViewController alloc] init];
        [ gAppWindows addSubview:currentModalViewController.view];
        [currentModalViewController presentViewController: gameCenterController animated: YES
                                               completion:nil];
    }
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController
                                           *)gameCenterViewController
{
    [currentModalViewController dismissViewControllerAnimated:YES completion:nil];
    [currentModalViewController.view removeFromSuperview];
    [currentModalViewController release];
    currentModalViewController = nil;
}

- (void) loadAchievements
{
    NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] init];
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements,NSError *error)
    {
        if (error == nil) {
            NSArray *tempArray = [NSArray arrayWithArray:achievements];
            for (GKAchievement *tempAchievement in tempArray)
            {
                [achievementDictionary setObject:tempAchievement forKey:tempAchievement.identifier];

                //NSLog(@"    completed:%d",tempAchievement.completed);
                //NSLog(@"    hidden:%d",tempAchievement.hidden);
                //NSLog(@"    lastReportedDate:%@",tempAchievement.lastReportedDate);
                //NSLog(@"    percentComplete:%f",tempAchievement.percentComplete);
                //NSLog(@"    identifier:%@",tempAchievement.identifier);
            }
       }
    }];
    
}



- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    NSMutableDictionary *achievementDictionary = [[NSMutableDictionary alloc] init];
    GKAchievement *achievement = [achievementDictionary objectForKey:identifier];
    
    if (achievement == nil)
    {
        achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [achievementDictionary setObject:achievement forKey:achievement.identifier];
    }
    
    return [[achievement retain] autorelease];
}


- (NSArray*)retrieveAchievmentMetadata
{
    //读取成就的描述
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
     ^(NSArray *descriptions, NSError *error) {
         if (error != nil)
         {
             // process the errors
             //NSLog(@"读取成就说明出错");
         }
         if (descriptions != nil)
         {
             // use the achievement descriptions.
             //for (GKAchievementDescription *achDescription in descriptions) {
                 //NSLog(@"1..identifier..%@",achDescription.identifier);
                 //NSLog(@"2..achievedDescription..%@",achDescription.achievedDescription);
                 //NSLog(@"3..title..%@",achDescription.title);
                 //NSLog(@"4..unachievedDescription..%@",achDescription.unachievedDescription);
                 //NSLog(@"5............%@",achDescription.image);
                 
                 //获取成就图片,如果成就未解锁,返回一个大文号
                 /*
                [achDescription loadImageWithCompletionHandler:^(UIImage *image, NSError *error) 
                                    {
                                       if (error == nil)
                                        {
                                          // use the loaded image. The image property is also populated with the same image.
                                            NSLog(@"成功取得成就的图片");
                                            UIImage *aImage = image;
                                            UIImageView *aView = [[UIImageView alloc] initWithImage:aImage];
                                            aView.frame = CGRectMake(50, 50, 200, 200);
                                            aView.backgroundColor = [UIColor clearColor];
                                            [[[CCDirector sharedDirector] openGLView] addSubview:aView];
                                        }else {
                                          NSLog(@"获得成就图片失败");
                                      }
                                    }];
                                     */
            // }
         }
     }];
    return nil;
}

//show friends request
//- (void) inviteUsingGK
//{
//    GKFriendRequestComposeViewController *friendRequestViewController = [[GKFriendRequestComposeViewController alloc] init];
//    friendRequestViewController.composeViewDelegate = self;
//    
//    currentModalViewController = [[UIViewController alloc] init];
//    [window addSubview:currentModalViewController.view];
//    [currentModalViewController presentViewController: friendRequestViewController animated: YES completion:nil];
//    [friendRequestViewController release];
//}
//
//-  (void)friendRequestComposeViewControllerDidFinish:(GKFriendRequestComposeViewController *)viewController
//{
//    [currentModalViewController dismissViewControllerAnimated:YES completion:nil];
//}
@end

@implementation RigsterController


- (void) showSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"你的账号改变，你要使用当前账号记录成就吗？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex !=[actionSheet cancelButtonIndex])
    {
        NSString *msg = nil;
     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"something was" message:msg delegate:self cancelButtonTitle:@"phew!" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [msg release];
    }
}
@end
