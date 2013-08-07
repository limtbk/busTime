//
//  NSDate+Extention.m
//  RialtoBusTime
//
//  Created by lim on 8/4/13.
//
//

#import "NSDate+Extention.h"

@implementation NSDate (Extention)

+ (NSDate *) dateWithHours:(NSInteger)hours andMinutes:(NSUInteger)minutes
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    [weekdayComponents setHour:hours];
    [weekdayComponents setMinute:minutes];
    NSDate *result = [gregorian dateFromComponents:weekdayComponents];
    return result;
}

+ (NSTimeInterval) timeIntervalToHours:(NSInteger)hours andMinutes:(NSInteger)minutes
{
    NSDate *today = [NSDate date];
    NSDate *start = [NSDate dateWithHours:hours andMinutes:minutes];
    NSTimeInterval interval = [start timeIntervalSinceDate:today];
    while (interval<0) {
        interval += 60*60*24;
    }
    return interval;
}

- (NSUInteger) dayOfWeek //monday = 0, sunday = 6
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSWeekdayCalendarUnit) fromDate:self];
    NSUInteger result = ((components.weekday+5)%7);
    return result;
}

@end

@implementation NSCalendar (GMTCalendar)

+(NSCalendar *) gmtCalendar
{
    NSCalendar *result = [NSCalendar currentCalendar];
    [result setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    [result setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    return result;
}

@end
