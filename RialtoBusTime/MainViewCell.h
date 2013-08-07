//
//  MainViewCell.h
//  GPSTest
//
//  Created by lim on 7/31/13.
//  Copyright (c) 2013 Elementumapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLabel.h"

@interface MainViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *startLabel;
@property (nonatomic, strong) IBOutlet UILabel *endLabel;
@property (nonatomic, strong) IBOutlet TimeLabel *timeLeftLabel;
@property (nonatomic, strong) IBOutlet UIImageView *notificationIcon;

@end
