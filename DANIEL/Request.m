//
//  Request.m
//  DANIEL
//
//  Created by Alexandre Ohayon on 30/12/2014.
//  Copyright (c) 2014 Alexandre Ohayon. All rights reserved.
//

#import "Request.h"
#import <Parse/Parse.h>

@implementation Request


+ (instancetype)instance {
    static Request *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MM-yy--HH-mm-ss"];
    }
    return self;
}



-(void)addUserWithImage:(UIImage *)image withName:(NSString*) name withAlertView:(BOOL)alertview withCompletion:(void(^)(bool success, NSDictionary *reply))completion{
    
    [self uploadingPicture:image withAlertView:alertview withCompletion:^(bool success, NSString *url) {
        if (success){
            
            NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         url, @"img_url",
                                         name,@"name",
                                         nil];
            NSDictionary *reply=[self postRequest:@"upload" andWithDictionary:requestData];
            completion(YES,reply);
        }
    }];
}


-(void)verifyImage:(UIImage *)image withAlertView:(BOOL)alertview withCompletion:(void(^)(bool success, NSDictionary *reply))completion{
    
    [self uploadingPicture:image withAlertView:alertview withCompletion:^(bool success, NSString *url) {
        if (success){

                
                NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             url, @"img_url",
                                             nil];
                NSDictionary *reply=[self postRequest:@"verify" andWithDictionary:requestData];
                
                //completion(YES,reply);
            //sleep(5);
            [percentageAlertView dismissWithClickedButtonIndex:0 animated:NO];

            completion(YES,reply);


        }
    }];
}





-(void)displayCheckingAlertView:(NSNotification *) notification{
    checkingAlertview=[[UIAlertView alloc]initWithTitle:@"Checking Access" message:[NSString stringWithFormat: @"Waiting for approval"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [checkingAlertview show];
}

-(void)uploadingPicture:(UIImage *)image withAlertView:(BOOL)alertview withCompletion:(void(^)(bool success,NSString *url))handler{
    UIAlertView *errorAlertView;
    
    percentageAlertView = [[UIAlertView alloc]initWithTitle:@"Uploading Image" message:@"0 %" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    if (alertview)
        [percentageAlertView show];
    errorAlertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Retry" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    //UIImage * imageToSend = [[ImageService instance]compressImageForUpload:self.photoImageView.image];
    NSString * imageName = [NSString stringWithFormat:@"img-%@.png",[dateFormatter stringFromDate:[NSDate date]]];
    //imageName=@"test";
    //PFFile *imageFile = [PFFile fileWithName:imageName data:UIImagePNGRepresentation([UIImage imageNamed:@"launchImage.png"])];
    image = [self compressImageForUpload:image];
    NSLog([NSString stringWithFormat:@"%i",[UIImagePNGRepresentation(image) length]]);
    PFFile *imageFile = [PFFile fileWithName:imageName data:UIImagePNGRepresentation(image)];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
 

            //[percentageAlertView dismissWithClickedButtonIndex:0 animated:0];
            
            //[self performSelectorOnMainThread:@selector(displayCheckingAlertView:) withObject:nil waitUntilDone:NO];

            NSString *urlForImage = imageFile.url;
            handler(YES,urlForImage);
            
        }
        else{
            [percentageAlertView dismissWithClickedButtonIndex:0 animated:0];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [errorAlertView show];
            handler(NO,nil);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        percentageAlertView.message = [NSString stringWithFormat:@"%i %%", percentDone];
        if(percentDone>=100){
            percentageAlertView.title = @"Checking Access";
            percentageAlertView.message = @"Waiting for approval";
            [percentageAlertView show];
        }
    }];
}


-(NSDictionary *)postRequest:(NSString *)type andWithDictionary: (NSDictionary *)dictionary{
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlForRequest= [NSString stringWithFormat:@"http://dm.ngrok.com/%@",type];
    [request setURL:[NSURL URLWithString:urlForRequest]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
    
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
    //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSError *e = nil;
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:requestHandler options:NSJSONReadingMutableContainers error:&e];
    //NSDictionary *jsonDict = [jsonString JSONValue];
    //NSDictionary *question = [dic objectForKey:@"allowed"];
    
    return dic;
}


-(UIImage *)compressImageForUpload:(UIImage *)imageToCompress{
    
    int maxFileSize = 300*1024;
    CGSize newSize= imageToCompress.size;
    NSData *imageData = UIImagePNGRepresentation(imageToCompress);
    
    while ([imageData length] > maxFileSize)
    {
        UIGraphicsBeginImageContext(newSize);
        [imageToCompress drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        imageToCompress = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        imageData = UIImagePNGRepresentation(imageToCompress);
        newSize= CGSizeMake(newSize.width/2, newSize.height/2);
    }
    
    return imageToCompress;
}


@end
