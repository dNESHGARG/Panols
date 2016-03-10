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
        
        if (image)
            self.image = image;
        
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
        
        if ([[data objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"])
        {
            NSString *dateString = [[data objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"MM/dd/YYYY"];
            NSDate *dateFromString = [[NSDate alloc] init];
            // voila!
            //dateString = @"06/10/2013";
            dateFromString = [dateFormatter dateFromString:dateString];
            
           // NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            //[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *newDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateFromString] ];
//            NSDate *date = [dateFormat dateFromString:dateStr];
//            //[dateFormatter setDateFormat:@"MMMM dd, YYYY"];
//            NSString* temp = [dateFormat stringFromDate:date];
            //NSDateFormatter *df = [[NSDateFormatter alloc] init];
            //[df setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
            //NSDate *myDate = [df dateFromString:dateStr];

            if(dateString.length > 0)
                self.dateStamp = dateString; //newDate;//[[data objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"] ;
            
        }
        
        if ([[data objectForKey:@"{GPS}"] objectForKey:@"Latitude"] && [[data objectForKey:@"{GPS}"] objectForKey:@"LatitudeRef"] && [[data objectForKey:@"{GPS}"] objectForKey:@"Longitude"] && [[data objectForKey:@"{GPS}"] objectForKey:@"LongitudeRef"])
        {
            self.latitude = [[data objectForKey:@"{GPS}"] objectForKey:@"Latitude"] ;
            self.latitudeRef = [[data objectForKey:@"{GPS}"] objectForKey:@"LatitudeRef"];
            self.longitude = [[data objectForKey:@"{GPS}"] objectForKey:@"Longitude"];
            self.longituderef = [[data objectForKey:@"{GPS}"] objectForKey:@"LongitudeRef"];
            
            self.coordinates = [NSString stringWithFormat:@"%@ %@  %@ %@", self.latitude, self.latitudeRef, [NSString stringWithFormat:@"-%@/", self.longitude], self.longituderef];
        }
        
    }
    
    return self;
}

@end
