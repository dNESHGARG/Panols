//
//  SRCameraSpecificationsCell.m
//  Splitarama
//
//  Created by Dinesh Garg on 1/25/16.
//  Copyright © 2016 Dinesh Garg. All rights reserved.
//

#import "SRCameraSpecificationsCell.h"
#import "SRImageMetadata.h"

@interface SRCameraSpecificationsCell()

@property (weak, nonatomic) IBOutlet UILabel *cameraInfo;
@property (weak, nonatomic) IBOutlet UILabel *shutterInfo;
@property (weak, nonatomic) IBOutlet UILabel *focalLength;
@property (weak, nonatomic) IBOutlet UILabel *isoInfo;
@property (weak, nonatomic) IBOutlet UILabel *resolutionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation SRCameraSpecificationsCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setCellWithData:(SRImageMetadata*)metaData {
    // Camera Make
    if (metaData.camera.length > 0)
        self.cameraInfo.text = metaData.camera;
    
    //Exposure
    if (metaData.shutterInfo.length > 0)
        self.shutterInfo.text = metaData.shutterInfo;
    
    // Focal Length
    if (metaData.focalLength.length > 0)
        self.focalLength.text = metaData.focalLength;
    // ISO
    if (metaData.isoInfo.length > 0)
        self.isoInfo.text = metaData.isoInfo;
    // Resolution
    if (metaData.resolution.length > 0)
        self.resolutionLabel.text = metaData.resolution;
    // File Size
    if (metaData.size.length > 0)
        self.sizeLabel.text = metaData.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithMetadat:(SRImageMetadata*)metaData {
//    self = [super init];
//    if (self != nil)
//    {
//        if (metaData.camera.length > 0)
//            self.cameraInfo.text = metaData.camera;
//        
//        if (metaData.focalLength.length > 0)
//            self.focalLength.text = metaData.isoInfo;
//        
//        if (metaData.isoInfo.length > 0)
//            self.isoInfo.text = metaData.extension;
//        
//        if (metaData.resolution.length > 0)
//            self.resolutionLabel.text = metaData.resolution;
//        
//        if (metaData.size.length > 0)
//            self.sizeLabel.text = metaData.size;
//        
//    }
//    
//    return self;
//}

@end
