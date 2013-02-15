//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Tom Billings on 15/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "SettingsViewController.h"
#include "CardMatchingGameResults.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (IBAction)clearScores
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
