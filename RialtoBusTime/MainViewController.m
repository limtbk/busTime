//
//  MainViewController.m
//  GPSTest
//
//  Created by lim on 7/28/13.
//  Copyright (c) 2013 Elementumapps. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewCell.h"
#import "NSDate+Extention.h"
#import "TimeSelectViewController.h"

#define MINUTES_BEFORE 10

@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, strong) IBOutlet UIView *tablePlaceholderView;
@property (nonatomic, strong) NSArray *timesData;
@property (nonatomic, strong) NSMutableArray *sortedTimesData;

@end

@implementation MainViewController

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tablePlaceholderView addSubview:self.tableViewController.view];
    self.tableViewController.view.frame = self.tablePlaceholderView.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedTimesData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedTimesData[section][@"times"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MainViewCell";
    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell...
    NSDictionary *timesBlock = self.sortedTimesData[indexPath.section];
    
    NSDictionary *time = timesBlock[@"times"][indexPath.row];
    
    NSString *startTimeStr = time[@"start"];
    cell.startLabel.text = startTimeStr;
    cell.endLabel.text = time[@"end"];
    
    cell.timeLeftLabel.hour = [time[@"hour"] integerValue];
    cell.timeLeftLabel.minute = [time[@"minute"] integerValue];
    
    cell.timeLeftLabel.first = ((indexPath.row == 0) && (indexPath.section == 0));
    
    cell.notificationIcon.hidden = YES;
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications) {
        if ([notification.userInfo[@"busTime"] isEqualToString:startTimeStr]) {
            cell.notificationIcon.hidden = NO;
            break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *timesBlock = self.sortedTimesData[section];
    return [NSString stringWithFormat:@"%@ - %@", timesBlock[@"startPoint"], timesBlock[@"endPoint"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *timesBlock = self.sortedTimesData[indexPath.section];
    NSDictionary *time = timesBlock[@"times"][indexPath.row];
    NSString *startTimeStr = time[@"start"];
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger selectedTime = 0;
    for (UILocalNotification *notification in scheduledNotifications) {
        if ([notification.userInfo[@"busTime"] isEqualToString:startTimeStr]) {
            selectedTime = [notification.userInfo[@"minutesBefore"] integerValue];
            break;
        }
    }
    
    TimeSelectViewController *timeSelectViewController = [[TimeSelectViewController alloc] init];
    
    timeSelectViewController.selectedTime = selectedTime;
    timeSelectViewController.indexPath = indexPath;
    timeSelectViewController.delegate = self;
    [self presentViewController:timeSelectViewController animated:YES completion:^{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }];
    return;
    
}

#pragma mark
-(void)sendNotificationForIndexPath:(NSIndexPath *)indexPath withDelay:(NSUInteger) delay
{
    NSDictionary *timesBlock = self.sortedTimesData[indexPath.section];
    NSDictionary *time = timesBlock[@"times"][indexPath.row];
    NSString *startTimeStr = time[@"start"];
    
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in scheduledNotifications) {
        if ([notification.userInfo[@"busTime"] isEqualToString:startTimeStr]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }

    if (delay>0) {
        NSDate *itemDate = [NSDate dateWithHours:[time[@"hour"] integerValue] andMinutes:[time[@"minute"] integerValue]];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        if (localNotification == nil)
            return;
        localNotification.fireDate = [itemDate dateByAddingTimeInterval:-delay*60];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = [NSString stringWithFormat:@"%d minutes to bus departure at %@", delay, startTimeStr];
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        
        userInfo[@"busTime"] = startTimeStr;
        userInfo[@"minutesBefore"] = [NSNumber numberWithInteger:delay];
        localNotification.userInfo = userInfo;
        
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    } else {
    }
    [self.tableViewController.tableView reloadData];

}

#pragma mark - Lazy

- (NSArray *)timesData
{
    if (!_timesData) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        path = [path stringByAppendingPathComponent:@"busTime.txt"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error = nil;
        NSArray *allSchedules = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        _timesData = [NSMutableArray arrayWithArray:allSchedules[0][@"scheduleData"]];
        for (NSDictionary *schedule in allSchedules) {
            NSUInteger currentDayOfWeek = [[NSDate date] dayOfWeek];
            NSArray *weekDays = schedule[@"days"];
            if ([weekDays containsObject:[NSNumber numberWithInteger:currentDayOfWeek]]) {
                _timesData = [NSMutableArray arrayWithArray:schedule[@"scheduleData"]];
                break;
            }
        }

        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return _timesData;
}

- (NSMutableArray *)sortedTimesData
{
    if (!_sortedTimesData) {
        NSMutableArray *result = [NSMutableArray array];
        
        for (NSDictionary *scheduleData in self.timesData) {
            NSMutableDictionary *mutableScheduleData = [NSMutableDictionary dictionaryWithDictionary:scheduleData];
            NSArray *times = scheduleData[@"times"];
            NSMutableArray *mutableTimes = [NSMutableArray array];
            for (NSDictionary *time in times) {
                NSMutableDictionary *mutableTime = [NSMutableDictionary dictionaryWithDictionary:time];
                NSString *startTimeStr = time[@"start"];
                NSArray *timeArr = [startTimeStr componentsSeparatedByString:@":"];
                NSUInteger hour = [timeArr[0] integerValue];
                NSUInteger minute = [timeArr[1] integerValue];
                NSUInteger secondsToStart = [NSDate timeIntervalToHours:hour andMinutes:minute];
                mutableTime[@"hour"] = [NSNumber numberWithInteger:hour];
                mutableTime[@"minute"] = [NSNumber numberWithInteger:minute];
                mutableTime[@"secondsToStart"] = [NSNumber numberWithInteger:secondsToStart];
                [mutableTimes addObject:mutableTime];
            }
            [mutableTimes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSMutableDictionary *dict1 = (NSMutableDictionary *)obj1;
                NSMutableDictionary *dict2 = (NSMutableDictionary *)obj2;
                NSNumber *secondsToStart1 = dict1[@"secondsToStart"];
                NSNumber *secondsToStart2 = dict2[@"secondsToStart"];
                return [secondsToStart1 compare:secondsToStart2];
            }];
            mutableScheduleData[@"times"] = mutableTimes;
            mutableScheduleData[@"minSecondsToStart"] = mutableTimes[0][@"secondsToStart"];
            [result addObject:mutableScheduleData];
        }
        [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSMutableDictionary *dict1 = (NSMutableDictionary *)obj1;
            NSMutableDictionary *dict2 = (NSMutableDictionary *)obj2;
            NSNumber *secondsToStart1 = dict1[@"minSecondsToStart"];
            NSNumber *secondsToStart2 = dict2[@"minSecondsToStart"];
            return [secondsToStart1 compare:secondsToStart2];
        }];
        _sortedTimesData = result;
        [self performSelector:@selector(refreshSortedTimesData) withObject:nil afterDelay:1.0];
    }
    return _sortedTimesData;
}

- (void) refreshSortedTimesData
{
    for (NSMutableDictionary *mutableScheduleData in self.sortedTimesData) {
        NSMutableArray *mutableTimes = mutableScheduleData[@"times"];
        for (NSMutableDictionary *mutableTime in mutableTimes) {
            NSUInteger hour = [mutableTime[@"hour"] integerValue];
            NSUInteger minute = [mutableTime[@"minute"] integerValue];
            NSUInteger secondsToStart = [NSDate timeIntervalToHours:hour andMinutes:minute];
            mutableTime[@"secondsToStart"] = [NSNumber numberWithInteger:secondsToStart];
        }
        [mutableTimes sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSMutableDictionary *dict1 = (NSMutableDictionary *)obj1;
            NSMutableDictionary *dict2 = (NSMutableDictionary *)obj2;
            NSNumber *secondsToStart1 = dict1[@"secondsToStart"];
            NSNumber *secondsToStart2 = dict2[@"secondsToStart"];
            return [secondsToStart1 compare:secondsToStart2];
        }];
        mutableScheduleData[@"minSecondsToStart"] = mutableTimes[0][@"secondsToStart"];
    }
    [self.sortedTimesData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSMutableDictionary *dict1 = (NSMutableDictionary *)obj1;
        NSMutableDictionary *dict2 = (NSMutableDictionary *)obj2;
        NSNumber *secondsToStart1 = dict1[@"minSecondsToStart"];
        NSNumber *secondsToStart2 = dict2[@"minSecondsToStart"];
        return [secondsToStart1 compare:secondsToStart2];
    }];

    [self.tableViewController.tableView reloadData];
    [self performSelector:@selector(refreshSortedTimesData) withObject:nil afterDelay:1.0];
}

@end
