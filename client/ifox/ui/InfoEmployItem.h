//
//  InfoEmployItem.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import <UIKit/UIKit.h>


@interface InfoEmployItem : UIView


@property( nonatomic ) int CreautreID , Index;

- ( void ) setData:( int )data;

- ( void ) updateData;

- ( void ) setSelect:( BOOL )b;



@end
