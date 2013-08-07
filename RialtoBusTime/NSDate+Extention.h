//
//  NSDate+Extention.h
//  RialtoBusTime
//
//  Created by lim on 8/4/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Extention)

+ (NSDate *) dateWithHours:(NSInteger)hours andMinutes:(NSUInteger)minutes;
+ (NSTimeInterval) timeIntervalToHours:(NSInteger)hours andMinutes:(NSInteger)minutes;
- (NSUInteger) dayOfWeek; //monday = 0, sunday = 6

@end

@interface NSCalendar (GMTCalendar)

+(NSCalendar *) gmtCalendar;

@end
