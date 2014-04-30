//
//  GameConfigLoader.h
//  ixyhz
//
//  Created by fox1 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//setDesignResolutionSize



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameKitHelper :  NSObject <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate,GKGameCenterControllerDelegate>
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    UIViewController *presentingViewController;
    GKMatch *match;
    NSString *accountID;
    BOOL gameAccountChanged;
}
@property (assign, readonly) BOOL gameAccountChanged;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (retain) NSString *accountID;

+ (GameKitHelper *)sharedGameKitHelper;
- (void) authenticateLocalUser;
-  (void) retrieveScores;
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;

- (void) showLeaderboard;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (void) loadAchievements;
- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier;
- (NSArray*)retrieveAchievmentMetadata;


//friends
- (void) retrieveFriends;
//Retrieving player details
- (void) loadPlayerData: (NSArray *) identifiers;
//show achievements
- (void) showAchievements;

//- (void) inviteUsingGK;
- (void) registerNewAccount;
- (void) showGameCenter;
- (void) showMachView;
@end


@interface RigsterController : UIViewController<UIActionSheetDelegate>
- (void)showSheet;
@end

//=====================对外接口========================