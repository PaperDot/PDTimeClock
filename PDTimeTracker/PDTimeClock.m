//
//
//  Created by PD5 on 3/21/14.
//  Copyright (c) 2014 PaperDot Design LLC. All rights reserved.
//

#import "PDTimeClock.h"
#import "PaperDot_Utility.h"


// Constants

#define kTimeClockTimeFormat            @"HH:mm:ss"
#define kTimeClockTimerInterval         1.0
#define kTimeClockBlankFormat           @"00:00:00"
#define kTimeClockStartButtonTitle      @"START"
#define kTimeClockPauseButtonTitle      @"PAUSE"
#define kTimeClockResumeButtonTitle     @"RESUME"
#define kTimeClockStopButtonTitle       @"STOP"


@interface PDTimeClock ()

@property (nonatomic, strong) NSTimer   *timeClockTimer;        // Timer that fires when time clock is active
@property (nonatomic, strong) NSDate    *timeClockInitialTime;  // Stores timestamp when user first starts clock
@property (nonatomic, strong) NSDate    *timeClockPausedTime;   // Stores timestamp when user pauses clock
@property (nonatomic, assign) BOOL      timeClockRunning;       // TRUE if clock is in action
@property (nonatomic, assign) BOOL      timeClockPaused;        // TRUE if clock is in "pause" mode

@end

@implementation PDTimeClock

#pragma mark - View Controller core functions

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"loaded time clock VC");
    
    // reset time clock display
    self.timeClockDisplayLabel.text = kTimeClockBlankFormat;
    self.timeClockRunning = FALSE;
    self.timeClockPaused = FALSE;
    
    [self.timeClockStartPauseButton setTitle:kTimeClockStartButtonTitle forState:UIControlStateNormal];
    [self.timeClockStartPauseButton setBackgroundImage:[UIImage imageNamed:@"Time Clock Start Button"] forState:UIControlStateNormal];
    
    self.timeClockStopButton.hidden = YES;
    
}

- (void) didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Time Clock functions

// --------------------------------------------------------
// Check time since first started and update clock display
// --------------------------------------------------------
- (void) updateTimeClock
{
    NSDate              *currentDate = [NSDate date];
    NSTimeInterval      timeInterval = [currentDate timeIntervalSinceDate:self.timeClockInitialTime];
    NSDate              *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter     *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:kTimeClockTimeFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and update the clock display
    NSString            *timeString = [dateFormatter stringFromDate:timerDate];
    self.timeClockDisplayLabel.text = timeString;
    
}


// --------------------------------------------------------
// Check time since first started and update clock display
// --------------------------------------------------------
- (void) recalcTimeClockInitialTime
{
    
    NSTimeInterval time_passed = [[NSDate date] timeIntervalSinceDate:self.timeClockInitialTime];
    
    NSTimeInterval pausedtime = [self.timeClockPausedTime timeIntervalSinceDate:self.timeClockInitialTime];
    self.timeClockInitialTime = [[NSDate date] dateByAddingTimeInterval:-pausedtime];
    
    DLog(@"time passed %f", time_passed);
    DLog(@"recalc clock at %@",self.timeClockInitialTime);
    
}


#pragma mark - IB Actions

// --------------------------------------------
// User touched the start time tracking button
// --------------------------------------------
- (IBAction) timeClockStartPauseTouched:(id)sender
{
    
    if (self.timeClockPaused)
    {
        
        DLog(@"User touched resume button.");
        
        [self recalcTimeClockInitialTime];
        
        self.timeClockPaused = NO;
        self.timeClockRunning = YES;
        self.timeClockTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeClockTimerInterval target:self selector:@selector(updateTimeClock) userInfo:nil repeats:YES];
        
        [self.timeClockStartPauseButton setTitle:kTimeClockPauseButtonTitle forState:UIControlStateNormal];
        
    }
    else
    {
        if (self.timeClockRunning)
        {
        
            DLog(@"User touched pause button.");
            
            self.timeClockPausedTime = [NSDate date];
            self.timeClockPaused = YES;
            self.timeClockRunning = NO;
            
            [self.timeClockTimer invalidate];
            self.timeClockTimer = nil;
        
            [self.timeClockStartPauseButton setTitle:kTimeClockResumeButtonTitle forState:UIControlStateNormal];
            
            DLog(@"Paused time %@",self.timeClockPausedTime);
            
        
        }
        else
        {
        
            DLog(@"User touched start button.");
        
            self.timeClockDisplayLabel.text = kTimeClockBlankFormat;
            self.timeClockInitialTime = [NSDate date];
            self.timeClockRunning = YES;
    
            // Create the clock timer
            self.timeClockTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeClockTimerInterval target:self selector:@selector(updateTimeClock) userInfo:nil repeats:YES];
        
            [self.timeClockStartPauseButton setTitle:kTimeClockPauseButtonTitle forState:UIControlStateNormal];
            [self.timeClockStartPauseButton setBackgroundImage:[UIImage imageNamed:@"Time Clock Pause Button"] forState:UIControlStateNormal];
        
            self.timeClockStopButton.hidden = NO;
            
            DLog(@"Start time %@",self.timeClockInitialTime);
        
        }
        
    }
    
}


// -------------------------------------------
// User touched the stop time tracking button
// -------------------------------------------
- (IBAction) timeClockStopTouched:(id)sender
{
    
    DLog(@"User touched stop button.");
    
    [self recalcTimeClockInitialTime];
    
    [self.timeClockTimer invalidate];
    self.timeClockTimer = nil;
    
    self.timeClockStopButton.hidden = YES;
    self.timeClockRunning = NO;
    self.timeClockPaused = NO;
    
    [self.timeClockStartPauseButton setTitle:kTimeClockStartButtonTitle forState:UIControlStateNormal];
    [self.timeClockStartPauseButton setBackgroundImage:[UIImage imageNamed:@"Time Clock Start Button"] forState:UIControlStateNormal];
    
    
}

@end
