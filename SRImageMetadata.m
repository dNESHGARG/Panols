//
//  SRImageMetadata.m
//  Splitarama
//
//  Created by Dinesh Garg on 1/27/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import "SRImageMetadata.h"

@implementation SRImageMetadata

- (instancetype) initImageMetadata:(NSDictionary *)data withImage:(id)image {
    
    self = [super init];
    
    if (self != nil){
        if ([[data objectForKey:@"{Exif}"] objectForKey:@"LensModel"])
            self.camera = [[data objectForKey:@"{Exif}"] objectForKey:@"LensModel"];
        
        if ([[data objectForKey:@"{Exif}"] objectForKey:@"FocalLength"])
            self.focalLength = [NSString stringWithFormat:@"%@mm",[[data objectForKey:@"{Exif}"] objectForKey:@"FocalLength"]];
        
        if ([[data objectForKey:@"{Exif}"] objectForKey:@"ISOSpeedRatings"])
        {
            NSArray *isoinformation = [[data objectForKey:@"{Exif}"] objectForKey:@"ISOSpeedRatings"];
            self.isoInfo = [NSString stringWithFormat:@"ISO %@",[isoinformation objectAtIndex:0]];
        }
        
        if ([[data objectForKey:@"{Exif}"] objectForKey:@"FNumber"] && [[data objectForKey:@"{Exif}"] objectForKey:@"ExposureTime"])
            self.shutterInfo = [NSString stringWithFormat:@"%@ sec at f/%@",[[data objectForKey:@"{Exif}"] objectForKey:@"ExposureTime"],[[data objectForKey:@"{Exif}"] objectForKey:@"FNumber"]];
        
        if ([data objectForKey:@"PixelWidth"] && [data objectForKey:@"PixelHeight"])
            self.resolution = [NSString stringWithFormat:@"%@ x %@",[data objectForKey:@"PixelWidth"],[data objectForKey:@"PixelHeight"]];
        
        if ([data objectForKey:@""])
        {
            NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
            NSInteger imageSize = imgData.length;
            self.size = [NSString stringWithFormat:@"%.2f MB", (float)imageSize/1024/1024];
        }
        
        if ([[data objectForKey:@"{GPS}"] objectForKey:@"Latitude"] && [[data objectForKey:@"{GPS}"] objectForKey:@"LatitudeRef"] && [[data objectForKey:@"{GPS}"] objectForKey:@"Longitude"] && [[data objectForKey:@"{GPS}"] objectForKey:@"LongitudeRef"])
        {
            self.latitude = [[data objectForKey:@"{GPS}"] objectForKey:@"Latitude"] ;
            self.latitudeRef = [[data objectForKey:@"{GPS}"] objectForKey:@"LatitudeRef"];
            self.longitude = [[data objectForKey:@"{GPS}"] objectForKey:@"Longitude"];
            self.longituderef = [[data objectForKey:@"{GPS}"] objectForKey:@"LongitudeRef"];
            
            self.coordinates = [NSString stringWithFormat:@"%@ %@  %@ %@",self.latitude,self.latitudeRef,self.longitude,self.longituderef];
        }
        
    }
    
    return self;
}

@end
