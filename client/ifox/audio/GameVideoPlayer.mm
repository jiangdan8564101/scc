//
//  GameVideoPlayer.m
//  ixyhz
//
//  Created by fox on 13-1-3.
//
//

#import "GameVideoPlayer.h"

@implementation GameVideoPlayer
@synthesize sel , object;


- ( void ) releaseVideoPlayer
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self ];
    [ self.view removeFromSuperview ];
    [ self stop ];
	
    if ( self.object )
    {
        [ self.object performSelector:self.sel withObject:self ];
    }
    
    [ self release ];
}

@end
