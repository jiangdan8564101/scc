

#import "GameCenterFile.h"
#import "cocos2d.h"

extern UIWindow* gAppWindows;

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation GameKitHelper

@synthesize gameAccountChanged;
@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize accountID;
//静态初始化 对外接口

static GameKitHelper *sharedHelper = nil;
static UIViewController* currentModalViewController = nil;
+ (GameKitHelper* )sharedGameKitHelper
{
    if ( !sharedHelper )
    {
        sharedHelper = [ [ GameKitHelper alloc ] init ];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer =@"4.3";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- ( id )init
{
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
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


- ( void )registerNewAccount
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [ nc addObserver:self
           selector:@selector( authenticationChanged )
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil ];

    accountID = [ GKLocalPlayer localPlayer ].playerID;
}


- (void)authenticationChanged
{
    if ( [ GKLocalPlayer localPlayer ].isAuthenticated &&!userAuthenticated )
    {
        //NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if ( ![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated )
    {
        //NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
        //[ GKNotificationBanner showBannerWithTitle:@"Warning!" message:@"Your account is unauthenticationed!" completionHandler:nil ];
    }
    
}


//friends
- ( void )retrieveFriends
{
    GKLocalPlayer* lp = [ GKLocalPlayer localPlayer ];
    
    if ( lp.authenticated )
    {
        [ lp loadFriendsWithCompletionHandler:^( NSArray *friends , NSError *error ) {
            if ( friends != nil )
            {
                [ self loadPlayerData: friends ];
            }
        }];
    }
}


//Retrieving player details
- ( void ) loadPlayerData:( NSArray* )identifiers
{
    [ GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error)
    {
        if ( error != nil )
        {
            // Handle the error.
            
        }
        if ( players != nil )
        {
            // Process the array of GKPlayer objects.
        }
    }];
}

- ( void ) authenticateLocalUser
{
    if ( !gameCenterAvailable )
        return;
    
    GKLocalPlayer* localPlayer = [ GKLocalPlayer localPlayer ];
    
    if ( localPlayer.isAuthenticated )
        return;
    
    [ localPlayer authenticateWithCompletionHandler:^( NSError* error )
     {
         if ( !error )
         {
             //[ self showGameCenter ];
         }
         else
         {
             GKGameCenterViewController* gameCenterController = [ [ GKGameCenterViewController alloc ] init ];
             
             gameCenterController.gameCenterDelegate = self;
             
             currentModalViewController = [ [ UIViewController alloc ] init ];
             [ gAppWindows addSubview:currentModalViewController.view ];
             [ currentModalViewController presentViewController:gameCenterController animated: YES completion:nil ];
         }
     }];
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
    if( !gameCenterAvailable || currentModalViewController || ![ GKLocalPlayer localPlayer].authenticated ) return;
    
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

- ( void )leaderboardViewControllerDidFinish:( GKLeaderboardViewController* )viewController
{
    if( currentModalViewController != nil )
    {
        [ currentModalViewController dismissModalViewControllerAnimated:NO ];
        [ currentModalViewController.view removeFromSuperview ];
        [ currentModalViewController release ];
        currentModalViewController = nil;
    }
}

- ( void )match:( GKMatch* )match didReceiveData:( NSData* )data fromPlayer:( NSString* )playerID
{

}

- ( void )showMachView
{
    if ( !gameCenterAvailable || currentModalViewController )
        return;
    
    GKMatchmakerViewController* matchshow = [ [ GKMatchmakerViewController alloc ] init ];
    
    matchshow.matchmakerDelegate = self;
    
    currentModalViewController = [ [ UIViewController alloc] init ];
    [ gAppWindows addSubview:currentModalViewController.view ];
    [ currentModalViewController presentViewController:matchshow animated: YES completion:nil ];
}

- ( void )matchmakerViewControllerWasCancelled:( GKMatchmakerViewController* )viewController
{
    [ currentModalViewController dismissModalViewControllerAnimated:YES ];
    [ currentModalViewController release ];
    [ currentModalViewController.view removeFromSuperview ];
    currentModalViewController = nil;
}

// Matchmaking has failed with an error
- ( void )matchmakerViewController:(GKMatchmakerViewController*)viewController didFailWithError:( NSError* )error
{
    [ currentModalViewController dismissModalViewControllerAnimated:YES ];
    [ currentModalViewController release ];
    [ currentModalViewController.view removeFromSuperview ];
    currentModalViewController = nil;
}

- ( void )achievementViewControllerDidFinish:( GKAchievementViewController* )viewController
{
    [ currentModalViewController dismissModalViewControllerAnimated:YES ];
    [ currentModalViewController release];
    [ currentModalViewController.view removeFromSuperview ];
    currentModalViewController = nil;
}

//report a achievement
- (void)reportAchievementIdentifier:( NSString* )identifier percentComplete:( float )percent
{
    GKAchievement *achievement = [ [ [ GKAchievement alloc ] initWithIdentifier:identifier ] autorelease ];
    
    if ( achievement )
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 
             }
             else
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
            }
         }];
    }
}

- (void) showAchievements
{
    if (!gameCenterAvailable || currentModalViewController) return;
    
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    
    //GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if ( achievements != nil )
    {
        achievements.achievementDelegate = self;
        achievements.viewState = GKGameCenterViewControllerStateAchievements;
        
        currentModalViewController = [[UIViewController alloc] init];
        [ gAppWindows addSubview:currentModalViewController.view];
        [ currentModalViewController presentViewController: achievements animated: YES
                         completion:nil];
    }
    [ achievements release ];
}

- ( void ) showGameCenter
{
    [ [ GameKitHelper sharedGameKitHelper] authenticateLocalUser ];
    
    if( !gameCenterAvailable || currentModalViewController || ![ GKLocalPlayer localPlayer ].authenticated )
        return;
    
    GKGameCenterViewController* gameCenterController = [ [ GKGameCenterViewController alloc ] init ];

    gameCenterController.gameCenterDelegate = self;
    
    currentModalViewController = [ [ UIViewController alloc ] init ];
    [ gAppWindows addSubview:currentModalViewController.view ];
    [ currentModalViewController presentViewController:gameCenterController animated: YES completion:nil ];
}


- ( void ) gameCenterViewControllerDidFinish:( GKGameCenterViewController * )gameCenterViewController
{
    [ currentModalViewController dismissViewControllerAnimated:YES completion:nil ];
    [ currentModalViewController.view removeFromSuperview ];
    [ currentModalViewController release ];
    currentModalViewController = nil;
}

- (void) loadAchievements
{
    NSMutableDictionary* achievementDictionary = [ [ NSMutableDictionary alloc ] init ];
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
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
     ^(NSArray *descriptions, NSError *error) {
         if (error != nil)
         {
             // process the errors
         }
         if (descriptions != nil)
         {
                     }
     }];
    return nil;
}
@end

@implementation RigsterController


- (void) showSheet {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"你的账号改变，你要使用当前账号记录成就吗？"
//                                  delegate:self
//                                  cancelButtonTitle:@"取消"
//                                  destructiveButtonTitle:@"确定"
//                                  otherButtonTitles:nil];
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    if(buttonIndex !=[actionSheet cancelButtonIndex])
//    {
//        NSString *msg = nil;
//     
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"something was" message:msg delegate:self cancelButtonTitle:@"phew!" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        [msg release];
//    }
}
@end
