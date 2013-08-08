//
//  TimeLabel.m
//  GPSTest
//
//  Created by lim on 8/4/13.
//  Copyright (c) 2013 Elementumapps. All rights reserved.
//

#import "TimeLabel.h"
#import "NSDate+Extention.h"

@implementation TimeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performSelector:@selector(refreshTime) withObject:self afterDelay:1.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performSelector:@selector(refreshTime) withObject:self afterDelay:1.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setupContent
{
    NSDate *today = [NSDate date];
    NSInteger interval = [NSDate timeIntervalToHours:self.hour andMinutes:self.minute];

    if (interval > 6 * 60 * 60) {
        self.textColor = [UIColor grayColor];
        self.text = [NSString stringWithFormat:@"00:00:00"];
    } else {
        self.textColor = [UIColor redColor];
        NSInteger hours = (interval / 3600) % 24;
        NSInteger minutes = (interval / 60) % 60;
        NSInteger seconds = interval % 60;
        self.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
}

- (void) refreshTime
{
    [self setupContent];
    [self performSelector:@selector(refreshTime) withObject:self afterDelay:1.0];
}

- (void) setHour:(NSUInteger)hour
{
    _hour = hour;
    [self setupContent];
}

- (void) setMinute:(NSUInteger)minute
{
    _minute = minute;
    [self setupContent];
}

- (void) setFirst:(BOOL)first
{
    _first = first;
    if (first) {
        self.font = [UIFont fontWithName:self.font.fontName size:30.0];
    } else
    {
        self.font = [UIFont fontWithName:self.font.fontName size:24.0];
    }
}

@end
