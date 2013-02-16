//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tom Billings on 29/1/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

- (NSUInteger)numPlayableCards;
- (NSString *)gameType;

// abstract methods and properties
- (Deck *)createDeck;
- (void)updateUIButton:(UIButton *)button withCard:(Card *)card;
- (NSAttributedString *)cardToAttributedString:(Card *)card;
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) NSUInteger matchingMode;

@end
