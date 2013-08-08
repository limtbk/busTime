//
//  TimeLabel.h
//  GPSTest
//
//  Created by lim on 8/4/13.
//  Copyright (c) 2013 Elementumapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLabel : UILabel

@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger minute;
@property (nonatomic, assign) BOOL first;

@end
