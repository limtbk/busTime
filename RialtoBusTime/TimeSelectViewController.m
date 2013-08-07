//
//  TimeSelectViewController.m
//  RialtoBusTime
//
//  Created by lim on 8/5/13.
//
//

#import "TimeSelectViewController.h"
#import "TimeSelectViewCell.h"

@interface TimeSelectViewController ()

@property (nonatomic, strong) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, strong) IBOutlet UIView *tablePlaceholderView;
@property (nonatomic, strong) NSArray *delays;
@property (nonatomic, assign) NSUInteger selectionNumber;

@end

@implementation TimeSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delays = @[@(0), @(5), @(10), @(15)];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.delays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TimeSelectViewCell";
    TimeSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeSelectViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell...
    if ([self.delays[indexPath.row] isEqual:@(0)]) {
        cell.titleLabel.text = @"No notification";
    } else {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ minutes before", self.delays[indexPath.row]];
    }
    if (indexPath.row == self.selectionNumber) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectionNumber = indexPath.row;
    [self.tableViewController.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate sendNotificationForIndexPath:self.indexPath withDelay:[self.delays[indexPath.row] integerValue]];
    }];
}

#pragma mark
-(void)setSelectedTime:(NSUInteger)selectedTime
{
    _selectedTime = selectedTime;
    self.selectionNumber = 0;
    for (NSUInteger index = 0; index < self.delays.count; index++) {
        if ([self.delays[index] integerValue] == selectedTime) {
            self.selectionNumber = index;
            break;
        }
    }
    [self.tableViewController.tableView reloadData];
}

@end
