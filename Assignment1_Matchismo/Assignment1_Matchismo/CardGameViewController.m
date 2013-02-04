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

@interface CardGameViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchingTypeSegment;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
	if (!_game) _game =
		[[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
										  usingDeck:[[PlayingCardDeck alloc] init]];
	return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
	_cardButtons = cardButtons;
	[self updateUI];
}

- (void)setMatchingTypeSegment:(UISegmentedControl *)matchingTypeSegment
{
	_matchingTypeSegment = matchingTypeSegment;
	[_matchingTypeSegment addTarget:self action:@selector(changeMatchingType) forControlEvents:UIControlEventValueChanged];
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
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	self.lastFlipResultLabel.hidden = NO;
	self.lastFlipResultLabel.text = self.game.lastFlipResult;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFlipCount:(int)flipCount
{
	_flipCount = flipCount;
	self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", _flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
	[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
	self.flipCount++;
	
	self.matchingTypeSegment.enabled = NO;
	[self updateUI];
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
		self.flipCount = 0;
		self.matchingTypeSegment.enabled = YES;
		[self updateUI];
	}
}

- (void)changeMatchingType
{
	if (self.matchingTypeSegment.selectedSegmentIndex == 0) {
		self.game.cardMatchingType = TwoCardMatchingType;
	} else if (self.matchingTypeSegment.selectedSegmentIndex == 1) {
		self.game.cardMatchingType = ThreeCardMatchingType;
	}
}
@end
