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

typedef enum  {
	TwoCardMatchingType,
	ThreeCardMatchingType
} CardMathingType;

@interface CardMatchingGame : NSObject <NSCopying>

@property (readonly, nonatomic) int score;
@property (strong, nonatomic) NSString *lastFlipResult; //Task 3: describes the results of the last flip
@property (nonatomic) CardMathingType cardMatchingType;

- (id)initWithCardCount:(NSUInteger)count
			  usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@end