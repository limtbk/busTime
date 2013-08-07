//
//  TimeSelectViewController.m
//  RialtoBusTime
//
//  Created by lim on 8/5/13.
//
//

#import "TimeSelectViewController.h"

@interface TimeSelectViewController ()

@property (nonatomic, strong) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, strong) IBOutlet UIView *tablePlaceholderView;

@end

@implementation TimeSelectViewController

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

@end
