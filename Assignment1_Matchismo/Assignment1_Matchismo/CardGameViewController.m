//
//  CardGameViewController.m
//  Assignment1_Matchismo
//
//  Created by 钟 子豪 on 13-2-1.
//  Copyright (c) 2013年 Pride Chung. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import <QuartzCore/QuartzCore.h>

@interface CardGameViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) CardMatchingGame *pausedGame;//before go back to history,use this property to save the current playing game
@property (strong, nonatomic) NSMutableArray *gameSnapshots;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingTypeSegment;
@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@end

@implementation CardGameViewController

- (void)viewDidLoad
{
	
	self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
													  usingDeck:[[PlayingCardDeck alloc] init]];
	self.gameSnapshots = [NSMutableArray array];
	[self.matchingTypeSegment addTarget:self action:@selector(changeMatchingType) forControlEvents:UIControlEventValueChanged];
	self.gameHistorySlider.maximumValue = 0.0;
	[self.gameHistorySlider addTarget:self action:@selector(backToHistory) forControlEvents:UIControlEventValueChanged];
	[self updateUI];
}

- (void)updateUI
{
	for (UIButton *cardButton in self.cardButtons) {
		Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
				
		UIImage *rikka = [UIImage imageNamed:@"Rikka"];
		
		//I don't know why I have to write as following to hidden the image of a button, otherwise it won't work, I jsut tried out this by luck.
		[cardButton setImage:rikka forState:UIControlStateNormal];
		[cardButton setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
		[cardButton setImage:[[UIImage alloc] init] forState:UIControlStateDisabled|UIControlStateSelected];
		[cardButton setTitle:card.contents forState:UIControlStateSelected];
		[cardButton setTitle:card.contents forState:UIControlStateDisabled|UIControlStateSelected];
		
		cardButton.selected = card.isFaceUp;
		cardButton.enabled = !card.isUnplayable;
		cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
		cardButton.layer.cornerRadius = 8;
		cardButton.clipsToBounds = YES;
		
		cardButton.enabled = ![self isPlayingHistory];
	}
	
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	self.lastFlipResultLabel.text = self.game.lastFlipResult;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.game.flipCount];
	
	if ([self isPlayingHistory]) {
		self.scoreLabel.alpha = 0.5;
		self.lastFlipResultLabel.alpha = 0.5;
		self.flipsLabel.alpha = 0.5;
	} else {
		self.scoreLabel.alpha = 1;
		self.lastFlipResultLabel.alpha = 1;
		self.flipsLabel.alpha = 1;
	}
}

- (IBAction)flipCard:(UIButton *)sender
{
	if ([self isPlayingHistory]) { //do nothing if it's showing history
		return;
	}
	
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.matchingTypeSegment.enabled = NO;
	[self updateUI];
	
	[self.gameSnapshots addObject:[self.game copy]]; //take a snapshot
	self.gameHistorySlider.maximumValue = [self.gameSnapshots count] > 0 ? [self.gameSnapshots count] -1 : 0;
	[self.gameHistorySlider setValue:self.gameHistorySlider.maximumValue animated:YES];
}

//task #4 add a button to re-deal
- (IBAction)deal:(id)sender
{
	// use an actionsheet to confirm
	UIActionSheet *redealConfirmActionSheet = [[UIActionSheet alloc] initWithTitle:@"Want to re-deal?"
																		  delegate:self
																 cancelButtonTitle:@"Don't re-deal"
															destructiveButtonTitle:@"Re-deal"
																 otherButtonTitles: nil];
	[redealConfirmActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		self.game =
		[[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
										  usingDeck:[[PlayingCardDeck alloc] init]];
		[self changeMatchingType];
		self.matchingTypeSegment.enabled = YES;
		[self.gameSnapshots removeAllObjects];
		self.gameHistorySlider.maximumValue = 0;
		[self updateUI];
	}
}

- (void)changeMatchingType
{
	self.game.cardMatchingType = self.matchingTypeSegment.selectedSegmentIndex ? ThreeCardMatchingType : TwoCardMatchingType;
}

- (void)backToHistory
{
	int historyIndex = roundf(self.gameHistorySlider.value);
	
	if (historyIndex >= self.gameHistorySlider.maximumValue) {
		//slider moved to right, should show the current game instead of history
		
		if (self.pausedGame) {
			self.game = self.pausedGame;
			self.pausedGame = nil;
		}
	} else {
		
		if (!self.pausedGame) {
			self.pausedGame = self.game; //save current game before back to history
		}
		
		self.game = self.gameSnapshots[historyIndex];
	}
	[self updateUI];
}

- (BOOL)isPlayingHistory
{
	return [self.gameSnapshots containsObject:self.game];
}

@end