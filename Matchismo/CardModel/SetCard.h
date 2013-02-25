//
//  SetCard.h
//  Matchismo
//
//  Created by Tom Billings on 10/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//
//  Cards in a Set game have 4 categories with 3 options each:
//      number:  1,2,3
//      symbol:  "diamond","oval","squiggle"
//      shading: "solid","striped","open"
//      color:   "red","green","purple"
//
//  In this implementation everything is abstracted out to just a
//  integer so that the controller can decide what to do with all
//  this logic

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number, symbol, shading, color;

+ (NSInteger)maxNumber;

@end
