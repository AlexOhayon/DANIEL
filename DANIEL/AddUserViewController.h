//
//  AddUserViewController.h
//  DANIEL
//
//  Created by Alexandre Ohayon on 30/12/2014.
//  Copyright (c) 2014 Alexandre Ohayon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddUserViewController : UIViewController

@property UIImage *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end
