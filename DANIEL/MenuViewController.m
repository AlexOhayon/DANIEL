//
//  MenuViewController.m
//  DANIEL
//
//  Created by Alexandre Ohayon on 30/12/2014.
//  Copyright (c) 2014 Alexandre Ohayon. All rights reserved.
//

#import "MenuViewController.h"
#import "AddUserViewController.h"
#import "Request.h"

@interface MenuViewController () <UIImagePickerControllerDelegate,UIActionSheetDelegate, UINavigationControllerDelegate>{
    UIImage *imageForUser;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [[Request instance] blurImage:[UIImage imageNamed:@"background.png"]];
    //[self performSegueWithIdentifier:@"AddUserSegue" sender:self];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addUser:(id)sender {

    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose Picture",
                            @"Take Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    [self presentViewController:picker animated:YES completion:NULL];
                }
                    break;
                case 1:
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        
                        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                              message:@"Device has no camera"
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles: nil];
                        
                        [myAlertView show];
                        
                    }
                    else{
                        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                        picker.delegate = self;
                        picker.allowsEditing = YES;
                        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                        [self presentViewController:picker animated:YES completion:NULL];
                    }
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    imageForUser = info[UIImagePickerControllerEditedImage];

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self performSegueWithIdentifier:@"AddUserSegue" sender:self];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"AddUserSegue"]){
        AddUserViewController *addUserVC= [segue destinationViewController];
        addUserVC.userImage= imageForUser;
    }
}


@end
