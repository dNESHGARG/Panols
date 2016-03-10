//
//  SRSplitViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 2/2/16.
//  Copyright © 2016 Panols. All rights reserved.
//

#import "SRSplitViewController.h"
#import "SRImageMetadata.h"

#define ALBUM_NAME @"Panols"

@interface SRSplitViewController ()<UIScrollViewDelegate, UIDocumentInteractionControllerDelegate>
{
    CGPoint _topScrollContentOffset;

}
@property (weak, nonatomic) IBOutlet UIView *navHeader;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat aspectRatio;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (weak, nonatomic) IBOutlet UIView *scrollViewTopView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *splitCropView;
@property (strong, nonatomic) IBOutlet UIView *translucentView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, assign) CGRect straightenRect;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (weak, nonatomic) IBOutlet UIButton *straightenButton;
@property (weak, nonatomic) IBOutlet UIButton *fillButton;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

@property (nonatomic, assign) BOOL  isFillOn;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (strong, nonatomic) IBOutlet UIView *straightenBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *straightDone;
@property (weak, nonatomic) IBOutlet UIButton *straightCancel;
@property (weak, nonatomic) IBOutlet UIScrollView *straightScaleView;

@property (strong, nonatomic) IBOutlet UIView *exportPanel;
@property (weak, nonatomic) IBOutlet UIButton *clearExportPanel;
@property (weak, nonatomic) IBOutlet UIView *imagesSavePanel;
@property (nonatomic, strong) NSString *title;

@end

@implementation SRSplitViewController

- (instancetype)initWithWithData:(SRImageMetadata*)metaData andCGImage:(CGImageRef)cgImage andTitle:(NSString*)navTitle{
    self = [super init];
    
    if (self != nil)
    {
        self.image = metaData.image;
        if(navTitle.length > 0)
            self.title = navTitle;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self contentViewLayout];
    [self translucentViewLayout];
    
    self.straightenRect = CGRectMake(0.0, self.scrollView.center.y - 291/2 -20.0, self.imageView.frame.size.width, self.imageView.frame.size.height);
  
    self.smallImageView.image = self.image;
    
    //self.imageView.center = self.scrollView.center;
    self.smallImageView.center = self.scrollView.center;
    
    self.isFillOn = NO;
    
    _topScrollContentOffset = CGPointMake(self.topScrollView.contentOffset.x, self.topScrollView.contentOffset.y);
    
    [self.view bringSubviewToFront:self.tabBarView];
    [self.view bringSubviewToFront:self.navHeader];
    
    self.navTitle.text = self.title;
    
}

- (void)contentViewLayout {
    self.imageView.image = self.image;
    
    self.scrollView.frame = self.imageView.frame;
    self.scrollView.contentSize = self.imageView.bounds.size;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    
    
    [self.contentView addSubview:self.scrollView];
    
    
    self.scrollView.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
        // Do any additional setup after loading the view from its nib.

}

- (void)translucentViewLayout {
    
    
    self.translucentView.frame = self.contentView.frame;//CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    self.topScrollView.frame = self.scrollView.frame;//self.translucentView.frame;
    self.topScrollView.contentSize = self.scrollView.contentSize;
    NSLog(@"Content size: %f", self.scrollView.contentSize.height);
    [self.translucentView addSubview:self.topScrollView];
    self.topScrollView.delegate = self;
    
    self.topScrollView.center = self.scrollView.center;
    
//    CGSize rect = [self sizeOfImage:self.image inAspectFitImageView:self.imageView];
//    
//    
//    CGFloat rectWidth = rect.width;
//    CGFloat rectHeight =  rect.height;
    
//    self.splitCropView.frame = CGRectMake(self.splitCropView.frame.origin.x, self.splitCropView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height/3);
    self.splitCropView.center =  CGPointMake(self.imageView.center.x, self.imageView.center.y);
    
    CGFloat height = self.topScrollView.frame.size.height/2 - self.splitCropView.frame.size.height/2;
    self.scrollViewTopView.frame = CGRectMake(0.0, 0.0, self.topScrollView.contentSize.width, height);
    self.scrollViewBottomView.frame = CGRectMake(0.0, self.topScrollView.frame.size.height/2 + self.splitCropView.frame.size.height/2, self.scrollView.contentSize.width, self.view.frame.size.height/2);
    
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.translucentView];
}

- (CGSize)sizeOfImage:(UIImage*)image inAspectFitImageView:(UIImageView*)imageView
{
    CGFloat imageViewWidth = imageView.bounds.size.width;
    CGFloat imageViewHeight = imageView.bounds.size.height;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat scaleFactor = MIN(imageViewWidth / imageWidth, imageViewHeight / imageHeight);
    
    return CGSizeMake(image.size.width*scaleFactor, image.size.height*scaleFactor);
}

- (void)setZoomScales {
    self.scrollView.minimumZoomScale = 1.0;//minScale;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.maximumZoomScale = 4.0;
    
    self.topScrollView.minimumZoomScale = 1.0;//minScale;
    self.topScrollView.zoomScale = 1.0;
    self.topScrollView.maximumZoomScale = 4.0;
}

- (void)viewWillLayoutSubviews {
    [self setZoomScales];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// cropping

-(UIImage*)cropImage:(CGRect)rect{
    
    // F = frame
    // i = image
    // iv = imageview
    // sv = self.view
    // of = offset
    
    //Frame Image in imageView coordinates
    //UIButton *button = sender;
    CGRect Fi_iv = [self frameForImage:self.image inImageViewAspectFit:self.imageView];
    
    //Frame ImageView in self.view coordinates
    CGRect Fiv_sv = self.imageView.frame;
    
    //Frame Image in self.view coordinates
    CGRect Fi_sv = CGRectMake(Fi_iv.origin.x + Fiv_sv.origin.x
                              ,Fi_iv.origin.y + Fiv_sv.origin.y,
                              Fi_iv.size.width, Fi_iv.size.height);
    //ScrollView offset
    CGPoint offset = self.scrollView.contentOffset;
    
    //Frame Image in offset coordinates
    CGRect Fi_of = CGRectMake(Fi_sv.origin.x - offset.x,
                              Fi_sv.origin.y - offset.y,
                              Fi_sv.size.width,
                              Fi_sv.size.height);
    
    CGFloat scale = self.imageView.image.size.width/Fi_of.size.width;
    
    //the crop frame in image offset coordinates
    CGRect Fcrop_iof = CGRectMake((rect.origin.x - Fi_of.origin.x)*scale,
                                  (rect.origin.y - Fi_of.origin.y)*scale,
                                  rect.size.width*scale,
                                  rect.size.height*scale);
    
    UIImage *image = [self image:self.imageView.image cropRect:Fcrop_iof];
    
    return image;
}

-(UIImage*)image:(UIImage *)image cropRect:(CGRect)frame
{
    // Create a new UIImage
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

-(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView
{
    float imageRatio = image.size.width / image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / image.size.height;
        
        float width = scale * image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / image.size.width;
        
        float height = scale * image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

// cropping


#pragma mark --

- (IBAction)backButtontapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)straightenButtonTapped:(id)sender {
    
    [self.straightScaleView setContentSize:CGSizeMake(self.view.frame.size.width+150.0, 75.0)];
    //[self.straightScaleView setContentOffset:CGPointMake(-75.0 , 0.0)];
    
    self.straightenBackgroundView.hidden = NO;
    //self.imageView.image = self.image;
}

- (IBAction)fillButtonTapped:(id)sender {
//    if(!self.isFillOn)
//    {
////        NSLog(@"***************   3   ***********************************************************");
////        NSLog(@"SCROLL VIEW Center y: %f",self.scrollView.center.y);
////        NSLog(@"Image View VIEW Center y: %f",self.imageView.center.y);
////        NSLog(@"too scroll View VIEW Center y: %f",self.topScrollView.center.y);
////        NSLog(@"Content VIEW Center y: %f",self.contentView.center.y);
////        NSLog(@"transclucent View VIEW Center y: %f",self.translucentView.center.y);
////        
////        self.imageView.frame = CGRectMake(0.0, self.scrollView.center.y - 40.0, self.scrollView.contentSize.width, 291.0);
////        self.imageView.image = self.image;
////        
//        self.isFillOn = YES;
//        self.imageView.hidden = NO;
//        self.smallImageView.hidden = YES;
//        self.topScrollView.contentOffset = _topScrollContentOffset;
//    }
//    else
//    {
////        NSLog(@"***************   2   ***********************************************************");
////        NSLog(@"SCROLL VIEW Center y: %f",self.scrollView.center.y);
////        NSLog(@"Image View VIEW Center y: %f",self.imageView.center.y);
////        NSLog(@"too scroll View VIEW Center y: %f",self.topScrollView.center.y);
////        NSLog(@"Content VIEW Center y: %f",self.contentView.center.y);
////        NSLog(@"transclucent View VIEW Center y: %f",self.translucentView.center.y);
////        self.imageView.frame = CGRectMake(0.0, self.scrollView.center.y - 40.0, self.view.frame.size.width, 291.);
//        
//        self.imageView.hidden = YES;
//        self.smallImageView.hidden = NO;
//        
//        self.isFillOn = NO;
//        self.topScrollView.contentOffset = _topScrollContentOffset;
//
//    }
}

- (IBAction)exportButtonTapped:(id)sender {
    //[self.view bringSubviewToFront:self.exportPanel];
    self.exportPanel.hidden = NO;
    self.imagesSavePanel.hidden = NO;
}
- (IBAction)dismissExportTapped:(id)sender {
    self.exportPanel.hidden = YES;
    self.imagesSavePanel.hidden = YES;
}

//The event handling method
//- (void)clearExportPanel:(UITapGestureRecognizer *)recognizer {
//    //[self.exportPanel removeFromSuperview];
//    self.exportPanel.hidden = YES;
//}

- (IBAction)clearExportButtonTapped:(id)sender {
    self.exportPanel.hidden = YES;
    self.imagesSavePanel.hidden = YES;
}

#pragma mark --
- (IBAction)straightDoneButtonTapped:(id)sender {
    
    self.straightenBackgroundView.hidden = YES;
}

- (IBAction)straightCancelButtonTapped:(id)sender {
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.topScrollView){
        self.scrollView.contentOffset = self.topScrollView.contentOffset;
    }

}
- (IBAction)exportImagesToPanolsGallery:(id)sender {
    [self splitImage];
    
    //[self.exportPanel removeFromSuperview];
    self.exportPanel.hidden = YES;
}

-(void)splitImage
{
    [self createImages];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshGallery"
     object:self];
}

- (void)createImages {
    
    UIImage *panolsImage = [self cropImage:self.splitCropView.frame];
    
    CGRect leftRect = CGRectMake(self.splitCropView.frame.origin.x, self.splitCropView.frame.origin.y , self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height);
    
    CGRect middleRect = CGRectMake(self.splitCropView.frame.size.width/3, self.splitCropView.frame.origin.y , self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height);
    
    CGRect rightRect = CGRectMake(2*self.splitCropView.frame.size.width/3, self.splitCropView.frame.origin.y , self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height);
    
    UIImage *imageLeft = [self cropImage:leftRect];
    UIImage *imageMiddle =[self cropImage:middleRect];
    UIImage *imageRight = [self cropImage:rightRect];
    
    NSArray *images = [[NSArray alloc] initWithObjects:panolsImage, imageLeft, imageMiddle, imageRight, nil];
    
    self.exportPanel.hidden = YES;
    self.imagesSavePanel.hidden = YES;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do something else
        [self findAlbumAssetCollection:ALBUM_NAME];
    });
    
    // Save panols Image to Panols Album
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveImageToPanolsGallery:images];
    });
    
    
}

//- (void)leftButtonTapped:(UIButton*)sender {
//    //[self writeMetadataToCreatedImage:self.leftImage];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self saveCroppedImage:self.leftImage];
//    });
//    
//    UIButton* myButton = (UIButton*)sender;
//    [myButton setTitle:@"Saved" forState:UIControlStateNormal];
//}
//
//- (IBAction)middleButtonTapped:(id)sender {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self saveCroppedImage:self.middleImage];
//    });
//    
//    UIButton* myButton = (UIButton*)sender;
//    [myButton setTitle:@"Saved" forState:UIControlStateNormal];
//}
//
//- (IBAction)rightButtonTapped:(id)sender {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self saveCroppedImage:self.rightImage];
//    });
//   
//    UIButton* myButton = (UIButton*)sender;
//    [myButton setTitle:@"Saved" forState:UIControlStateNormal];
//}

- (NSString *)pathForPanolsDirectory:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/Panols"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    dataPath = [dataPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    
    return dataPath;
}

- (void)shareOnInstagram:(UIImage*)image {
    NSString* imagePath = [NSString stringWithFormat:@"%@/instagramShare.igo", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    NSLog(@"Image Size >>> %@", NSStringFromCGSize(image.size));
    
    self.documentController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    self.documentController.delegate = self;
    self.documentController.UTI = @"com.instagram.exclusivegram";
    [self.documentController presentOpenInMenuFromRect: self.view.frame inView:self.view animated:YES ];
}

- (NSString*)dateString {
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    
    return dateString;
}
#pragma mark --

-(void)saveImageToPanolsGallery:(NSArray *)images{
    
    for (UIImage *image in images) {
        __block BOOL retStat = false;
        NSData *newImageSize = UIImageJPEGRepresentation(image, 1);
        UIImage *imageNew = [UIImage imageWithData:newImageSize];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHFetchResult *photosAsset;
            PHAssetCollection *collection = [self findAlbumAssetCollection:ALBUM_NAME];
            PHObjectPlaceholder *placeholder;
            placeholder = [[PHAssetChangeRequest creationRequestForAssetFromImage:imageNew] placeholderForCreatedAsset];
            photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection assets:photosAsset];
            [albumChangeRequest addAssets:@[placeholder]];
        } completionHandler:^(BOOL success, NSError *error) {
            if (success){
                retStat = true;
            }
            else{
                NSLog(@"%@", error);
            }}];
    }
}

-(PHAssetCollection*)findAlbumAssetCollection:(NSString*)albumName{
    //PHAssetCollection *collection;
    __block PHAssetCollection *collection;
    __block PHObjectPlaceholder *placeholder;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", albumName];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    // Create the album
    if (!collection)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *createAlbum = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            placeholder = [createAlbum placeholderForCreatedAssetCollection];
        } completionHandler:^(BOOL success, NSError *error) {
            if (success)
            {
                PHFetchResult *collectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[placeholder.localIdentifier]
                                                                                                            options:nil];
                collection = collectionFetchResult.firstObject;
            }
        }];
    }
    
    return collection;
}

-(void)saveCroppedImage:(UIImage *)image{
    __block BOOL retStat = false;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //PHObjectPlaceholder *placeholder;
        //placeholder = [[PHAssetChangeRequest creationRequestForAssetFromImage:image] placeholderForCreatedAsset];
        //PHAssetChangeRequest *changeRequest =
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //[changeRequest addAssets:@[placeholder]];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success){
            retStat = true;
        }
        else{
            NSLog(@"%@", error);
        }}];
}

@end
