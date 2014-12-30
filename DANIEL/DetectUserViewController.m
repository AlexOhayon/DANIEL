//
//  DetectUserViewController.m
//  DANIEL
//
//  Created by Alexandre Ohayon on 30/12/2014.
//  Copyright (c) 2014 Alexandre Ohayon. All rights reserved.
//

#import "DetectUserViewController.h"
#import <Parse/Parse.h>
#import "Request.h"


@interface DetectUserViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIImage *imageForUser;
    UIAlertView *percentageAlertView;
    UIAlertView *errorAlertView;
    NSDateFormatter *dateFormatter;
    NSString *urlForImage;
}

@end

@implementation DetectUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yy--HH-mm-ss"];
    
    [self openCamera];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openCamera{
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
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    imageForUser = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [[Request instance] verifyImage:imageForUser withCompletion:^(bool success, NSDictionary *reply) {
        NSLog(reply);
        if ([reply[@"allowed" ] isEqualToString:@"true"]){
            [[[UIAlertView alloc]initWithTitle:@"Access Allowed" message:[NSString stringWithFormat: @"The door has been opened for you %@", reply[@"allowed"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else
            [[[UIAlertView alloc]initWithTitle:@"Access Denied" message:[NSString stringWithFormat: @"The door is locked"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
    //[self performSegueWithIdentifier:@"AddUserSegue" sender:self];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*
-(void)uploadingPicture{
    percentageAlertView = [[UIAlertView alloc]initWithTitle:@"Uploading Image" message:@"0 %" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [percentageAlertView show];
    errorAlertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Retry" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    //UIImage * imageToSend = [[ImageService instance]compressImageForUpload:self.photoImageView.image];
    NSString * imageName = [NSString stringWithFormat:@"img-%@.png",[dateFormatter stringFromDate:[NSDate date]]];
    PFFile *imageFile = [PFFile fileWithName:imageName data:UIImagePNGRepresentation(imageForUser)];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            urlForImage = imageFile.url;
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                      urlForImage, @"url",
                                                      nil];
            NSError *error;
            [[Request instance]postRequestWithDictionary: requestData];
        }
        else{
            [percentageAlertView dismissWithClickedButtonIndex:0 animated:0];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [errorAlertView show];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        percentageAlertView.message = [NSString stringWithFormat:@"%i %%", percentDone];
    }];
}
*/

@end
