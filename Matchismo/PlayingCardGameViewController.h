//
//  PlayingCardGameViewController.h
//  Matchismo
//
//  Created by Tom Billings on 12/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController : CardGameViewController

@property (strong, nonatomic) CardMatchingGame *game;

@end
