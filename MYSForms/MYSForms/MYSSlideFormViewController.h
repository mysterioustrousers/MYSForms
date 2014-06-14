//
//  MYSSlideFormViewController.h
//  MYSForms
//
//  Created by Adam Kirk on 6/6/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormViewController.h"


@interface MYSSlideFormViewController : MYSFormViewController

@property (nonatomic, assign, readonly) BOOL appearedFirstTime;

- (BOOL)shouldSlideInAutomatically;

- (void)slideInWithCompletion:(void (^)(void))completion;

@end
