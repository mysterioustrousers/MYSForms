//
//  MYSFormTokenFieldCell.m
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTokenFieldCell.h"
#import "MYSFormTokenFieldElement.h"
#import "MYSFormTokenFieldCell-Private.h"


static CGFloat tokenSpacing = 8.0;


@interface MYSFormTokenFieldCell ()
@property (nonatomic, copy)          NSArray  *tokenControls;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@end


@implementation MYSFormTokenFieldCell

+ (CGSize)sizeRequiredForElement:(MYSFormTokenFieldElement *)element width:(CGFloat)width
{
    return CGSizeMake(width, 150);
}

- (NSString *)valueKeyPath
{
    return @"tokenDisplayStrings";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = tokenSpacing;
    CGFloat y = tokenSpacing;
    for (UIControl *control in self.tokenControls) {
        CGRect frame = control.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        control.frame = frame;
        // increment x,y for next token bubble
        x = CGRectGetMaxX(frame) + tokenSpacing;
        if (x > self.contentView.frame.size.width - tokenSpacing) {
            x = tokenSpacing;
            y += CGRectGetMaxY(frame) + tokenSpacing;
        }
    }
}


#pragma mark - Public

- (void)setTokenDisplayStrings:(NSArray *)tokenDisplayStrings
{
    _tokenDisplayStrings = tokenDisplayStrings;

    for (UIControl *control in self.tokenControls) {
        [control removeFromSuperview];
    }

    // create buttons and add them to the cell
    NSMutableArray *tokenControls = [NSMutableArray new];
    for (NSString *string in tokenDisplayStrings) {
        UIControl *control = [self controlForTokenWithText:string];
        [tokenControls addObject:control];
        [self addSubview:control];
    }
    self.tokenControls = tokenControls;

    [self setNeedsLayout];
}

- (UIControl *)controlForTokenWithText:(NSString *)text
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName : font }];
    size.height += 10;
    size.width += 14;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = font;
    button.frame = CGRectMake(0, 0, size.width, size.height);
    button.layer.cornerRadius = size.height / 2.0;
    return button;
}


#pragma mark - Actions

- (IBAction)addButtonWasTapped:(id)sender
{
    
}

@end
