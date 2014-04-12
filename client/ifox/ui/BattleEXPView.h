//
//  BattleEXPView.h
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import <UIKit/UIKit.h>
#import "UILabelStroke.h"

@interface BattleEXPView : UIView
{
    UILabelStroke* nameLabel;
    UILabelStroke* expLabel;
    UIImageView* image;
    
    int exp1;
    int exp2;
    
    int width;
}

- ( void ) start:( int )e1 :( int )e2;
- ( void ) initBattleEXPView;

- ( void ) update:( float )d;


@end
