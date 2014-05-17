//
//  ASHSpringyCollectionViewFlowLayout.m
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

/*
 
 This implementation is based on https://github.com/TeehanLax/UICollectionView-Spring-Demo
 which I developed at Teehan+Lax. Check it out.
 
 */

#import "MYSFormCollectionViewSpringyLayout.h"


@interface MYSFormCollectionViewSpringyLayout ()
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet      *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat           latestDelta;
@end


@implementation MYSFormCollectionViewSpringyLayout

@synthesize isDynamicsEnabled = _isDynamicsEnabled;

- (void)commonInit
{
    self.minimumInteritemSpacing    = 0;
    self.minimumLineSpacing         = 5;
    self.dynamicAnimator            = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet       = [NSMutableSet new];
    self.isDynamicsEnabled          = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];

    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size},
                                     -100,
                                     -100);

    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];

    // update dynamic animator items and behaviors on insert/delete
    if (!self.isDynamicsEnabled) {
        [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
            UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
            for (UICollectionViewLayoutAttributes *attributes in itemsInVisibleRectArray) {
                if ([attributes.indexPath isEqual:item.indexPath]) {
                    item.frame = attributes.frame;
                    [self.dynamicAnimator updateItemUsingCurrentState:item];
                    springBehaviour.anchorPoint = attributes.center;
                }
            }
        }];
    }

    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    // Step 1: Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
    }];
    
    // Step 2: Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];

        springBehaviour.length      = 0.0f;
        springBehaviour.damping     = 0.8f;
        springBehaviour.frequency   = 1.0f;

        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat scrollResistance = yDistanceFromTouch / 1500.0f;

            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta * scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta * scrollResistance);
            }
            item.center = center;
        }

        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat scrollResistance = yDistanceFromTouch / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta * scrollResistance);
        }
        else {
            center.y += MIN(delta, delta * scrollResistance);
        }
        item.center = center;

        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];

    return NO;
}

@end
