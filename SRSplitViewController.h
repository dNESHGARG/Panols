//
//  SRSplitViewController.h
//  Splitarama
//
//  Created by Dinesh Garg on 2/2/16.
//  Copyright © 2016 Panols. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SRImageMetadata;

@import Photos;
@import ImageIO;

@interface SRSplitViewController : UIViewController

- (instancetype)initWithWithData:(SRImageMetadata*)metaData andCGImage:(CGImageRef)cgImage andTitle:(NSString*)navTitle;

@end
