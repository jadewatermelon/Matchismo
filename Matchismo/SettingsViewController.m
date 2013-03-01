//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Tom Billings on 15/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SettingsViewController.h"
#include "CardMatchingGameResults.h"

@interface SettingsViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIAlertView *alert;

@end

@implementation SettingsViewController

- (UIAlertView *)alert {
    if (!_alert) _alert = [[UIAlertView alloc] initWithTitle:@"Clear Scores"
                                                     message:@"Are you sure you want to reset all scores?"
                                                    delegate:self
                                           cancelButtonTitle:@"No"
                                           otherButtonTitles:@"Yes", nil];
    return _alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Yes"]) {
        [CardMatchingGameResults resetGameResults];
    }
}

- (IBAction)clearScores
{
    [self.alert show];
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
