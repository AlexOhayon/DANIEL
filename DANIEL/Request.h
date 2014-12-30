//
//  Request.h
//  DANIEL
//
//  Created by Alexandre Ohayon on 30/12/2014.
//  Copyright (c) 2014 Alexandre Ohayon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Request : NSObject{
    NSDateFormatter *dateFormatter;
}

+ (instancetype)instance;

-(void)addUserWithImage:(UIImage *)image withName:(NSString*) name withCompletion:(void(^)(bool success, NSDictionary *reply))completion;
-(void)verifyImage:(UIImage *)image withCompletion:(void(^)(bool success, NSDictionary *reply))completion;

-(UIImage *)blurImage:(UIImage *)imageToBlur;

@end
