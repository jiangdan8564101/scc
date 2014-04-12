//
//  ItemPlayerInfoView.h
//  sc
//
//  Created by fox on 13-12-2.
//
//

#import "UIHandler.h"
#import "UILabelStroke.h"
#import "CreatureConfig.h"
#import "ItemConfig.h"
#import "SkillConfig.h"

@interface ItemPlayerInfoView : UIView
{
    
}

- ( void ) initView;

- ( void ) setData:( CreatureCommonData* )c;

@end


