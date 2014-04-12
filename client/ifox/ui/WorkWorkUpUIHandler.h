//
//  WorkWorkUpUIHandler.h
//  sc
//
//  Created by fox on 13-11-21.
//
//

#import "UIHandler.h"

@interface WorkWorkUpUIHandler : UIHandler
{
    UIImageView* ivItem0;
    UIImageView* ivItem1;

    UILabel* nameItem0;
    UILabel* nameItem1;
    
    UILabel* needItem0;
    UILabel* needItem1;
    
    UILabel* numItem0;
    UILabel* numItem1;
    
    int type;
}


+ ( WorkWorkUpUIHandler* ) instance;

- ( void ) setData:( int )t;

@end
