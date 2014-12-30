//
//  AddUserViewController.m
//  DANIEL
//
//  Created by Alexandre Ohayon on 30/12/2014.
//  Copyright (c) 2014 Alexandre Ohayon. All rights reserved.
//

#import "AddUserViewController.h"
#import "Request.h"


@interface AddUserViewController () <UITextFieldDelegate>

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userImageView.image = self.userImage;
    NSLog([NSString stringWithFormat:@"%i",[UIImagePNGRepresentation(self.userImage) length]]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addUserButton:(id)sender {
    [[Request instance]addUserWithImage:self.userImageView.image withName:self.userNameTextField.text withCompletion:^(bool success, NSDictionary *reply) {
        NSLog(reply);
        if ([reply[@"success" ] isEqualToString:@"true"]){
            [[[UIAlertView alloc]initWithTitle:@"User Added" message:@"Successfully added" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        }
        else
            [[[UIAlertView alloc]initWithTitle:@"User Denied" message:[NSString stringWithFormat: @"Retry register the user"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
