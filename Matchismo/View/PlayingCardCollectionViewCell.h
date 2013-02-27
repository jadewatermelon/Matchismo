//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Tom Billings on 26/2/2013.
//  Copyright (c) 2013 Tom Billings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
