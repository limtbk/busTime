//
//  TimeLabel.m
//  GPSTest
//
//  Created by lim on 8/4/13.
//  Copyright (c) 2013 Elementumapps. All rights reserved.
//

#import "TimeLabel.h"

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
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    [weekdayComponents setHour:self.hour];
    [weekdayComponents setMinute:self.minute];
    NSDate *start = [gregorian dateFromComponents:weekdayComponents];
    NSInteger interval = [start timeIntervalSinceDate:today];
    interval = (interval < 0)?(interval + 60*60*24):(interval);
    NSInteger hours = interval / 3600;
    NSInteger minutes = (interval / 60) % 60;
    NSInteger seconds = interval % 60;
    
    if (interval > 12 * 60 * 60) {
        self.textColor = [UIColor grayColor];
        self.text = [NSString stringWithFormat:@"00:00:00"];
    } else {
        self.textColor = [UIColor redColor];
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

@end
