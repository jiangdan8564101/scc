//
//  GameVideoPlayer.h
//  ixyhz
//
//  Created by fox on 13-1-3.
//
//

#import <MediaPlayer/MediaPlayer.h>

@interface GameVideoPlayer : MPMoviePlayerController

@property( nonatomic , assign ) NSObject* object;
@property( nonatomic , assign ) SEL sel;

- ( void ) releaseVideoPlayer;


@end
