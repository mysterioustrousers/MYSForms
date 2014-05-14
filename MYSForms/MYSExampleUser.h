//
//  MYSFakeUser.h
//  MYSForms
//
//  Created by Adam Kirk on 5/2/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//


@interface MYSExampleUser : NSObject
@property (nonatomic, copy  ) NSString   *firstName;
@property (nonatomic, copy  ) NSString   *lastName;
@property (nonatomic, copy  ) NSString   *email;
@property (nonatomic, copy  ) NSString   *password;
@property (nonatomic, assign) NSUInteger yearsOld;
@property (nonatomic, assign) BOOL       isLegalAdult;
@end
