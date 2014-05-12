//
//  MYSFormImagePickerCell.m
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormImagePickerCell.h"
#import "MYSFormImagePickerElement.h"


NSString * const MYSFormImagePickerCellActionSheetButtonTakePhoto           = @"Take Photo";
NSString * const MYSFormImagePickerCellActionSheetButtonChooseFromLibrary   = @"Choose From Library";


@interface MYSFormImagePickerCell () <UIActionSheetDelegate>
@end


@implementation MYSFormImagePickerCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.backgroundColor = [UIColor darkGrayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.width / 2.0;
}

+ (CGSize)sizeRequiredForElement:(MYSFormImagePickerElement *)element width:(CGFloat)width
{
    return CGSizeMake(width, 100);
}




#pragma mark - Public

- (NSString *)valueKeyPath
{
    return @"imageView.image";
}

- (void)populateWithElement:(MYSFormImagePickerElement *)element
{
    self.imageView.image    = element.image;
    self.label.text         = element.label;
}




#pragma mark - Actions

- (IBAction)cellWasTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:(self.imageView.image ? @"Remove Image" : nil)
                                                    otherButtonTitles:
                                  MYSFormImagePickerCellActionSheetButtonTakePhoto,
                                  MYSFormImagePickerCellActionSheetButtonChooseFromLibrary,
                                  nil];
    [actionSheet showInView:self.window];
}




#pragma mark - DELEGATE action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    UIImagePickerController *imagePickerController = [UIImagePickerController new];
//    imagePickerController.delegate = self;
//
//    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//    if ([buttonTitle isEqualToString:@"Take Photo"]) {
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    if ([buttonTitle isEqualToString:@"Choose From Library"]) {
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
}






@end

