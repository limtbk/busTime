//
//  TimeSelectViewController.h
//  RialtoBusTime
//
//  Created by lim on 8/5/13.
//
//

#import <UIKit/UIKit.h>

@protocol TimeSelectViewControllerDelegate <NSObject>

-(void)sendNotificationForIndexPath:(NSIndexPath *)indexPath withDelay:(NSUInteger) delay;

@end

@interface TimeSelectViewController : UIViewController

@property (nonatomic, assign) NSUInteger selectedTime;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<TimeSelectViewControllerDelegate> delegate;

@end
