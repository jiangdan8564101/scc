//
//  GameVideoManager.m
//  ixyhz
//
//  Created by fox on 12-12-14.
//
//

#import "GameVideoManager.h"
#import "GameDefine.h"

@implementation GameVideoManager


GameVideoManager* gGameVideoManager = NULL;
+ ( GameVideoManager* ) instance
{
    
    if ( !gGameVideoManager )
    {
        gGameVideoManager = [ [ GameVideoManager alloc ] init ];
    }
    
    return gGameVideoManager;
}


- ( GameVideoPlayer* ) Play:( NSString* )path :(UIView*)view
{
    NSURL* movieURL = [ NSURL fileURLWithPath:path ];
    
    GameVideoPlayer* player = [ [ GameVideoPlayer alloc ] initWithContentURL:movieURL ];
    player.view.userInteractionEnabled = NO;
    player.backgroundView.backgroundColor = [ UIColor clearColor ];
	player.view.tintColor = [ UIColor blackColor ];
    
    [ player.view setFrame:view.bounds ];
    [ view addSubview: player.view ];

    player.backgroundView.backgroundColor = [UIColor clearColor];
    //player.backgroundView.alpha = 0.5f;
    //player.view.alpha = 0.5f;
    
    
//    CALayer* layer = [ CALayer layer ];
//    layer.frame = player.view.frame;
//    layer.contents = player.view;
//    player.view.layer.mask = layer;
    
    [ player setRepeatMode:MPMovieRepeatModeOne ];
    [ player setScalingMode:MPMovieScalingModeNone ];
    [ player setControlStyle:MPMovieControlStyleNone ];
    [ player setFullscreen:NO ];
    //[ player setCurrentPlaybackRate:100.0f ];
    [ player play ];
    
    [ [ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player ];
    
    return player;
}

- ( GameVideoPlayer* ) PlayURL:( NSString* )path :(UIView*)view
{
    NSURL* movieURL = [ NSURL URLWithString:path ];
    
    GameVideoPlayer* player = [ [ GameVideoPlayer alloc ] initWithContentURL:movieURL ];
    
    player.view.userInteractionEnabled = NO;
    
    [ player.view setFrame:view.bounds ];
    [ view addSubview: player.view ];
    
    [ player setRepeatMode:MPMovieRepeatModeOne ];
    [ player setScalingMode:MPMovieScalingModeNone ];
    [ player setControlStyle:MPMovieControlStyleNone ];
    [ player setFullscreen:NO ];
    //[ player setCurrentPlaybackRate:100.0f ];
    [ player play ];
    
    [ [ NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player ];
    
    return player;
}

- ( void )PlayOne:( NSString* )path :(UIView*)view :( NSObject* )obj :(SEL)s
{
    GameVideoPlayer* player = [ self Play:path :view ];
    [ player setRepeatMode:MPMovieRepeatModeNone ];
    
    player.object = obj;
    player.sel = s;
}

- ( void )PlayOneURL:( NSString* )path :(UIView*)view :( NSObject* )obj :(SEL)s
{
//    NSString* str = [ NSString stringWithFormat:@"%@%@%@" , GD_ACTION_PATH , GD_ACTION_PATH_ACTION , path ];
//    
//    GameVideoPlayer* player = [ self PlayURL:str :view ];
//    [ player setRepeatMode:MPMovieRepeatModeNone ];
//    
//    player.object = obj;
//    player.sel = s;
}


-(void) movieFinish:(NSNotification*)notification
{
    GameVideoPlayer* player = (GameVideoPlayer*)notification.object;
    
	[ [ NSNotificationCenter defaultCenter ] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player ];
    [ player.view removeFromSuperview ];
    [ player stop ];
    
    if ( player.object )
    {
        [ player.object performSelector:player.sel withObject:player ];
    }
    
    [ player release ];
    player = nil;
}

@end
