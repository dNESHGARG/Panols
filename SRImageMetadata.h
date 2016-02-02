//
//  SRImageMetadata.h
//  Splitarama
//
//  Created by Dinesh Garg on 1/27/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRImageMetadata : NSObject

- (instancetype)initImageMetadata:(NSDictionary*)data withImage:(UIImage*)image;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSArray *keyWords;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *camera;
@property (nonatomic, strong) NSString *shutter;
@property (nonatomic, strong) NSString *focalLength;
@property (nonatomic, strong) NSString *exposureNumber;
@property (nonatomic, strong) NSString *isoInfo;
@property (nonatomic, strong) NSString *shutterInfo;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *coordinates;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *latitudeRef;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *longituderef;

@end
