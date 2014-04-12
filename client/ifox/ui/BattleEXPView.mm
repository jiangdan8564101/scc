//
//  BattleEXPView.m
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "BattleEXPView.h"

@implementation BattleEXPView



- ( void ) initBattleEXPView
{
    nameLabel = ( UILabelStroke* )[ self viewWithTag:100 ];
    expLabel = ( UILabelStroke* )[ self viewWithTag:200 ];
    image = ( UIImageView* )[ self viewWithTag:300 ];
    
    width = image.frame.size.width;
}

- ( void ) start:( int )e1 :( int )e2
{
    exp1 = e1;
    exp2 = e2;
    
    CGRect f = image.frame;
    f.size.width = width * e1;
    [ image setFrame:f ];
}


- ( void ) update:( float )d
{
    
}

@end
