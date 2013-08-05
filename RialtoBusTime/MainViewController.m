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

#define MINUTES_BEFORE 5

@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, strong) IBOutlet UIView *tablePlaceholderView;
@property (nonatomic, strong) NSArray *timesData;

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


//    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.timesData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.timesData[section][@"times"] count];
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
    NSDictionary *timesBlock = self.timesData[indexPath.section];
    
    NSDictionary *time = timesBlock[@"times"][indexPath.row];
    
    NSString *startTimeStr = time[@"start"];
    cell.startLabel.text = startTimeStr;
    cell.endLabel.text = time[@"end"];
    
    NSArray *timeArr = [startTimeStr componentsSeparatedByString:@":"];
    cell.timeLeftLabel.hour = [timeArr[0] integerValue];
    cell.timeLeftLabel.minute = [timeArr[1] integerValue];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *timesBlock = self.timesData[section];
    return [NSString stringWithFormat:@"%@ - %@", timesBlock[@"startPoint"], timesBlock[@"endPoint"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *timesBlock = self.timesData[indexPath.section];
    NSDictionary *time = timesBlock[@"times"][indexPath.row];
    NSString *startTimeStr = time[@"start"];
    NSArray *timeArr = [startTimeStr componentsSeparatedByString:@":"];
    
    NSDate *itemDate = [NSDate dateWithHours:[timeArr[0] integerValue] andMinutes:[timeArr[1] integerValue]];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil)
        return;
    localNotification.fireDate = [itemDate dateByAddingTimeInterval:-MINUTES_BEFORE*60];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = [NSString stringWithFormat:@"%d minutes to bus departure at %@", MINUTES_BEFORE, startTimeStr];
//    localNotif.alertAction = @"View Details";
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotif.applicationIconBadgeNumber = 0;
    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
//    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Lazy

- (NSArray *)timesData
{
    if (!_timesData) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        path = [path stringByAppendingPathComponent:@"busTime.txt"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *error = nil;
        _timesData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return _timesData;
}

@end
