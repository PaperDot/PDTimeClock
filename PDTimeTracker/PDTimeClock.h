//
//
//  Created by PD5 on 3/21/14.
//  Copyright (c) 2014 PaperDot Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTimeClock : UIViewController

@property (strong, nonatomic) IBOutlet UILabel  *timeClockDisplayLabel;
@property (weak, nonatomic) IBOutlet UIButton   *timeClockStartPauseButton;
@property (weak, nonatomic) IBOutlet UIButton   *timeClockStopButton;

- (IBAction) timeClockStartPauseTouched:(id)sender;
- (IBAction) timeClockStopTouched:(id)sender;

@end
