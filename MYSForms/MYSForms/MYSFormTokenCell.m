//
//  MYSFormTokenCell.m
//  MYSForms
//
//  Created by Adam Kirk on 12/26/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormTokenCell.h"
#import "MYSFormTokenElement.h"
#import "MYSFormTokenCell-Private.h"


static CGFloat tokenSpacing = 8.0;


@interface MYSFormTokenCell ()
@property (nonatomic, copy) NSArray *tokenControls;
@end


@implementation MYSFormTokenCell

+ (CGSize)sizeRequiredForElement:(MYSFormTokenElement *)element width:(CGFloat)width
{
    UIEdgeInsets insets = [self cellContentInset];
    MYSFormTokenCell *measurementCell = [[MYSFormTokenCell alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
    [measurementCell setTokenDisplayStrings:[element currentModelValue]];
    NSArray *frames = [measurementCell tokenFrames];
    CGFloat maxY = 0;
    for (NSValue *frameValue in frames) {
        CGRect frame = [frameValue CGRectValue];
        if (CGRectGetMaxY(frame) > maxY) {
            maxY = CGRectGetMaxY(frame);
        }
    }
    // top inset is already calculated in with the dummy frames
    return CGSizeMake(width, (maxY ?: 20) + insets.bottom);
}

+ (UIEdgeInsets)cellContentInset
{
    UIEdgeInsets insets = [super cellContentInset];
//    insets.top = insets.bottom = insets.left;
    return insets;
}

- (NSString *)valueKeyPath
{
    return @"tokenDisplayStrings";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self tokenFrames] enumerateObjectsUsingBlock:^(NSValue *frameValue, NSUInteger idx, BOOL *stop) {
        if (idx < [self.tokenControls count]) {
            UIControl *token = self.tokenControls[idx];
            token.backgroundColor = [self tintColor];
            token.frame = [frameValue CGRectValue];
        }
        else {
            self.addButton.frame = [frameValue CGRectValue];
        }
    }];
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

    [self.addButton removeFromSuperview];
    [self addSubview:self.addButton];

    [self setNeedsLayout];
}

- (UIControl *)controlForTokenWithText:(NSString *)text
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName : font }];
    size.height += tokenSpacing;
    size.width += tokenSpacing * 3.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = font;
    button.frame = CGRectMake(0, 0, size.width, size.height);
    button.layer.cornerRadius = size.height / 2.0;
    [button addTarget:self action:@selector(tokenWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark - Actions

- (IBAction)tokenWasTapped:(id)sender
{
    NSInteger index = [self.tokenControls indexOfObject:sender];
    [self.tokenCellDelegate tokenCell:self didTapToken:sender index:index];
}

- (IBAction)addButtonWasTapped:(id)sender
{
    [self.tokenCellDelegate tokenCellDidTapAddToken:self];
}


#pragma mark - Private

- (NSArray *)tokenFrames
{
    NSMutableArray *frames = [NSMutableArray new];
    UIEdgeInsets insets = [[self class] cellContentInset];
    CGFloat x = insets.left;
    CGFloat y = insets.top;
    for (UIControl *control in self.tokenControls) {
        CGRect frame = control.frame;
        CGFloat nextX = x + CGRectGetWidth(frame) + tokenSpacing;
        if (nextX > self.bounds.size.width - insets.right) {
            x = insets.left;
            y += tokenSpacing + CGRectGetHeight(frame);
        }
        frame.origin.x = x;
        frame.origin.y = y;
        [frames addObject:[NSValue valueWithCGRect:frame]];
        x = CGRectGetMaxX(frame) + tokenSpacing;
    }
    CGRect frame = self.addButton.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = 22;
    frame.size.height = 22;
    [frames addObject:[NSValue valueWithCGRect:frame]];
    return [frames copy];
}

@end
