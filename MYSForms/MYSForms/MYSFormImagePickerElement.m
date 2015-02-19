//
//  MYSFormImagePickerElement.m
//  MYSForms
//
//  Created by Adam Kirk on 5/10/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSFormImagePickerElement.h"
#import "MYSFormImagePickerCell-Private.h"
#import "MYSFormTheme.h"


NSString * const MYSFormImagePickerCellActionSheetButtonTakePhoto           = @"Take Photo";
NSString * const MYSFormImagePickerCellActionSheetButtonChooseFromLibrary   = @"Choose From Library";
NSString * const MYSFormImagePickerCellActionSheetButtonCancel              = @"Cancel";
NSString * const MYSFormImagePickerCellActionSheetButtonRemovePhoto         = @"Remove Photo";


@interface MYSFormImagePickerElement () <MYSFormImagePickerCellDelegate,
                                         UIActionSheetDelegate,
                                         UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate>
@end


@implementation MYSFormImagePickerElement

+ (instancetype)imagePickerElementWithLabel:(NSString *)label modelKeyPath:(NSString *)modelKeyPath
{
    MYSFormImagePickerElement *element  = [self new];
    element.label                       = label;
    element.modelKeyPath                = modelKeyPath;
    return element;
}

- (BOOL)canAddElement
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)setCell:(MYSFormImagePickerCell *)cell
{
    [super setCell:cell];
    cell.imagePickerCellDelegate = self;
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        self.imagePickerController                    = [UIImagePickerController new];
        _imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePickerController.delegate               = self;
        _imagePickerController.allowsEditing          = YES;
    }
    return _imagePickerController;
}

- (BOOL)isEditable
{
    return YES;
}

- (void)beginEditing
{
    [self formImagePickerCellWasTapped:nil];
}

- (void)configureClassDefaultTheme:(MYSFormTheme *)theme
{
    theme.backgroundColor = [UIColor clearColor];
}


#pragma mark - DELEGATE image picker cell

- (void)formImagePickerCellWasTapped:(MYSFormImagePickerCell *)cell
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:MYSFormImagePickerCellActionSheetButtonTakePhoto];
    }
    [actionSheet addButtonWithTitle:MYSFormImagePickerCellActionSheetButtonChooseFromLibrary];

    if (cell.imageView.image) {
        actionSheet.destructiveButtonIndex =
        [actionSheet addButtonWithTitle:MYSFormImagePickerCellActionSheetButtonRemovePhoto];
    }

    actionSheet.cancelButtonIndex =
    [actionSheet addButtonWithTitle:MYSFormImagePickerCellActionSheetButtonCancel];

    [self.delegate formElement:self didRequestPresentationOfActionSheet:actionSheet];
}


#pragma mark - DELEGATE action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:MYSFormImagePickerCellActionSheetButtonTakePhoto]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([buttonTitle isEqualToString:MYSFormImagePickerCellActionSheetButtonChooseFromLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if ([buttonTitle isEqualToString:MYSFormImagePickerCellActionSheetButtonRemovePhoto]) {
        [self updateCell];
        [self.delegate formElement:self valueDidChange:nil];
        return;
    }
    else if ([buttonTitle isEqualToString:MYSFormImagePickerCellActionSheetButtonCancel]) {
        return;
    }

    [self.delegate formElement:self didRequestPresentationOfViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - DELEGATE image picker

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    [self updateCell];
    [self.delegate formElement:self valueDidChange:image];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
