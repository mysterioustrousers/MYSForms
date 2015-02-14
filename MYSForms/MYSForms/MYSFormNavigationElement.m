//
//  MYSFormNavigationElement.m
//  MYSForms
//
//  Created by Adam Kirk on 1/31/15.
//  Copyright (c) 2015 Mysterious Trousers. All rights reserved.
//

#import "MYSFormNavigationElement.h"
#import "MYSFormNavigationCell-Private.h"


@interface MYSFormNavigationElement () <MYSFormNavigationCellDelegate>
@property (nonatomic, copy) UIViewController *(^destinationViewControllerBlock)(void);
@property (nonatomic, copy) NSString *label;
@end


@implementation MYSFormNavigationElement

@synthesize modelKeyPath=_modelKeyPath;

+ (instancetype)navigationElementWithLabel:(NSString *)label
            destinationViewControllerBlock:(UIViewController * (^)())destinationViewControllerBlock;
{
    MYSFormNavigationElement *element = [self new];
    element.label = label;
    element.destinationViewControllerBlock = destinationViewControllerBlock;
    return element;
}

- (void)setCell:(MYSFormNavigationCell *)cell
{
    [super setCell:cell];
    cell.navigationCellDelegate = self;
}


#pragma mark - DELEGATE token field cell

- (void)navigationCellDidTapCell:(MYSFormNavigationCell *)cell
{
    if (self.destinationViewControllerBlock) {
        UIViewController *destinationViewController = self.destinationViewControllerBlock();
        destinationViewController.title = self.label;
        [self.delegate formElement:self didRequestPushOfViewController:destinationViewController];
    }
}


@end
