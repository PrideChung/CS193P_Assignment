//
//  CardMatchingGame.m
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-2.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

@property (readwrite, nonatomic) int score;
@property (nonatomic) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count
			  usingDeck:(Deck *)deck
{
	self = [super init];
	
	if (self) {
		for (int i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				self.cards[i] = card;
			} else {
				self = nil;
				break;
			}
		}
	}
	
	return self;
}

- (NSMutableArray *)cards
{
	if (!_cards) _cards = [[NSMutableArray alloc] init];
	return _cards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index
{
	Card *card = [self cardAtIndex:index];
	
	if (card && !card.isUnplayable) {
		
		if (!card.isFaceUp) {
			for (Card *otherCard in self.cards) {
				if (otherCard.isFaceUp && !otherCard.isUnplayable) {
					int matchScore = [card match:@[otherCard]];
					
					if (matchScore) {
						card.unplayable = YES;
						otherCard.unplayable = YES;
						self.score += matchScore * MATCH_BONUS;
					} else {
						otherCard.faceUp = NO;
						self.score -= MISMATCH_PENALTY;
					}
					break;
				}
				
			}
			
			self.score -= FLIP_COST;
		}
				
		card.faceUp = !card.isFaceUp;
	}
}

- (Card *)cardAtIndex:(NSUInteger)index
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
