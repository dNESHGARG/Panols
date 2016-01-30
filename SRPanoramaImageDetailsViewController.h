//
//  SRPanoramaImageDetailsControllerViewController.h
//  Splitarama
//
//  Created by Dinesh Garg on 1/25/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@import Photos;
@import ImageIO;

@interface SRPanoramaImageDetailsViewController : UIViewController

- (instancetype)initWithAsset:(PHAsset*)asset andImage:(UIImage*)image;

@end
