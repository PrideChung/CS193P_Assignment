//
//  CardMatchingGame.h
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-2.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;


- (id)initWithCardCount:(NSUInteger)count
			  usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;


@end
