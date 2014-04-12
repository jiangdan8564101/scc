//
//  UILabelStroke.h
//  ixyhz
//
//  Created by Rain on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelStroke : UILabel
{
    UIColor* strokeColor;
    CGFloat strokeLineWidth;
}

- ( void ) setStrokeColor:( UIColor* )color;
- ( void ) setStrokeLineWidth:( CGFloat )lineWidth;
- ( void ) setLabelText:( NSString* )t;


@end
