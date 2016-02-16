//
//  SRSplitViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 2/2/16.
//  Copyright © 2016 Panols. All rights reserved.
//

#import "SRSplitViewController.h"
#import "SRImageMetadata.h"

@interface SRSplitViewController ()<UIScrollViewDelegate, UIDocumentInteractionControllerDelegate>
{
    CGPoint _topScrollContentOffset;
    CGFloat xAspect;
    CGFloat yAspect;
    
    CGFloat xMove;
    CGFloat yMove;
}
@property (weak, nonatomic) IBOutlet UIView *navHeader;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic, assign) CGImageRef inputCGImage;
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
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, assign) CGRect straightenRect;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

@property (nonatomic, strong) UIImage* leftImage;
@property (nonatomic, strong) UIImage* middleImage;
@property (nonatomic, strong) UIImage* rightImage;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *straightenButton;
@property (weak, nonatomic) IBOutlet UIButton *fillButton;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

@property (nonatomic, assign) BOOL  isFillOn;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (strong, nonatomic) IBOutlet UIView *straightenBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *straightDone;
@property (weak, nonatomic) IBOutlet UIButton *straightCancel;
@property (weak, nonatomic) IBOutlet UIScrollView *straightScaleView;


@end

@implementation SRSplitViewController

- (instancetype)initWithWithData:(SRImageMetadata*)metaData andCGImage:(CGImageRef)cgImage; {
    self = [super init];
    
    if (self != nil)
    {
        self.inputCGImage = cgImage;
        self.image = metaData.image;
        
        self.width = CGImageGetWidth(self.inputCGImage);
        self.height = CGImageGetHeight(self.inputCGImage);
        self.aspectRatio = self.width/self.height;
    }
    
    return self;
}

- (void)dealloc{
    CFRelease(self.inputCGImage);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    //self.imageView.image = self.image;
    
    //self.contentView.frame = self.view.frame;//CGRectMake(0.0, 87.0, self.view.frame.size.width, self.view.frame.size.height-107-self.tabBarView.frame.size.height+20.0);
    
    self.scrollView.frame = self.contentView.frame;//CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height + 40.0);
    //self.scrollView.frame = CGRectMake(0.0, -40.0, self.contentView.frame.size.width, self.contentView.frame.size.height + 80.0);
    //self.scrollView.center =  self.view.center;
    
    [self.scrollView setContentSize:(CGSizeMake(291.0*self.aspectRatio, self.view.frame.size.height+200))];
    
    //self.height = self.imageView.frame.size.height;
    //self.width = self.imageView.frame.size.width;
    self.straightenRect = CGRectMake(0.0, self.scrollView.center.y - 291/2 -20.0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    //self.imageView.frame = self.straightenRect;
    self.imageView.frame = CGRectMake(0.0, self.scrollView.center.y - 40.0, self.scrollView.contentSize.width, 291.0);
    self.imageView.image = self.image;
    //self.smallImageView.frame = self.straightenRect;
    self.smallImageView.image = self.image;
    
    self.imageView.center = self.scrollView.center;
    self.smallImageView.center = self.scrollView.center;
    
    xAspect = self.width/self.imageView.frame.size.width;
    yAspect = self.height/self.imageView.frame.size.height;
    //self.imageView.frame = CGRectMake(0.0, 0.0, self.scrollView.contentSize.width, 291.0);
    
//    self.scrollViewTopView.frame = CGRectMake(0.0, 0.0, self.scrollView.contentSize.width, self.scrollViewTopView.frame.size.height);
//    self.scrollViewBottomView.frame = CGRectMake(0.0, self.scrollViewBottomView.frame.origin.y, self.scrollView.contentSize.width, self.scrollViewBottomView.frame.size.height);
//    
    
    //self.scrollView.center = self.view.center;
    //self.imageView.center = self.scrollView.center;
    
    self.translucentView.frame = self.contentView.frame;//CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height+40.0);
    self.translucentView.center = self.scrollView.center;
    self.splitCropView.center = self.translucentView.center;
    self.scrollViewTopView.frame = CGRectMake(0.0, 0.0, self.translucentView.frame.size.width, self.translucentView.frame.size.height/2 -self.splitCropView.frame.size.height/2);
    self.scrollViewBottomView.frame = CGRectMake(0.0, self.translucentView.frame.size.height/2 +self.splitCropView.frame.size.height/2, self.translucentView.frame.size.width, self.translucentView.frame.size.height/2-self.splitCropView.frame.size.height/2);
    
    //self.imageView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y);
    //self.translucentView.center = self.view.center;
    //[self addGestureRecognizersToPiece:self.scrollViewTopView];
    self.topScrollView = [[UIScrollView alloc] init];
    self.topScrollView.frame = self.translucentView.frame;
    self.topScrollView.contentSize = self.scrollView.contentSize;
    NSLog(@"Content size: %f", self.scrollView.contentSize.height);
    [self.translucentView addSubview:self.topScrollView];
    self.topScrollView.backgroundColor = [UIColor clearColor];
    self.topScrollView.delegate = self;
    self.topScrollView.center = self.scrollView.center;

    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:self.translucentView];
    
    
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    // Do any additional setup after loading the view from its nib.
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.translucentView.backgroundColor = [UIColor clearColor];
    
    
    self.isFillOn = NO;
    
    _topScrollContentOffset = CGPointMake(self.topScrollView.contentOffset.x, self.topScrollView.contentOffset.y);
    
    [self.view bringSubviewToFront:self.tabBarView];
    [self.view bringSubviewToFront:self.navHeader];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --

- (IBAction)backButtontapped:(id)sender {
    self.leftImage = nil;
    self.middleImage = nil;
    self.rightImage = nil;
    
    NSArray *viewsToRemove = [self.splitCropView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)straightenButtonTapped:(id)sender {
    
    [self.straightScaleView setContentSize:CGSizeMake(self.view.frame.size.width+150.0, 75.0)];
    //[self.straightScaleView setContentOffset:CGPointMake(-75.0 , 0.0)];
    
    self.straightenBackgroundView.hidden = NO;
    //self.imageView.image = self.image;
}

- (IBAction)fillButtonTapped:(id)sender {
    if(!self.isFillOn)
    {
//        NSLog(@"***************   3   ***********************************************************");
//        NSLog(@"SCROLL VIEW Center y: %f",self.scrollView.center.y);
//        NSLog(@"Image View VIEW Center y: %f",self.imageView.center.y);
//        NSLog(@"too scroll View VIEW Center y: %f",self.topScrollView.center.y);
//        NSLog(@"Content VIEW Center y: %f",self.contentView.center.y);
//        NSLog(@"transclucent View VIEW Center y: %f",self.translucentView.center.y);
//        
//        self.imageView.frame = CGRectMake(0.0, self.scrollView.center.y - 40.0, self.scrollView.contentSize.width, 291.0);
//        self.imageView.image = self.image;
//        
        self.isFillOn = YES;
        self.imageView.hidden = NO;
        self.smallImageView.hidden = YES;
        self.topScrollView.contentOffset = _topScrollContentOffset;
    }
    else
    {
//        NSLog(@"***************   2   ***********************************************************");
//        NSLog(@"SCROLL VIEW Center y: %f",self.scrollView.center.y);
//        NSLog(@"Image View VIEW Center y: %f",self.imageView.center.y);
//        NSLog(@"too scroll View VIEW Center y: %f",self.topScrollView.center.y);
//        NSLog(@"Content VIEW Center y: %f",self.contentView.center.y);
//        NSLog(@"transclucent View VIEW Center y: %f",self.translucentView.center.y);
//        self.imageView.frame = CGRectMake(0.0, self.scrollView.center.y - 40.0, self.view.frame.size.width, 291.);
        
        self.imageView.hidden = YES;
        self.smallImageView.hidden = NO;
        
        self.isFillOn = NO;
        self.topScrollView.contentOffset = _topScrollContentOffset;

    }
}

- (IBAction)exportButtonTapped:(id)sender {
    self.clearButton.hidden = NO;
    [self.view bringSubviewToFront:self.splitCropView];
    [self splitImage];
    
    self.exportButton.enabled = NO;
    self.fillButton.enabled = NO;
    self.straightenButton.enabled = NO;
    self.topScrollView.userInteractionEnabled = NO;
    
    self.splitCropView.userInteractionEnabled = YES;
    
}

#pragma mark --
- (IBAction)straightDoneButtonTapped:(id)sender {
    
    self.straightenBackgroundView.hidden = YES;
}

- (IBAction)straightCancelButtonTapped:(id)sender {
}

#pragma mark --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.topScrollView){
        self.scrollView.contentOffset = self.topScrollView.contentOffset;
        xMove = scrollView.contentOffset.x;
        yMove = scrollView.contentOffset.y;
        NSLog(@"self scrollView contentOffset: X = %f, Y = %f, ",self.scrollView.contentOffset.x, self.scrollView.contentOffset.y);

    }

}

-(void)splitImage
{
    
    if (self.leftImage)
        self.leftImage = nil;
    
    if (self.middleImage)
        self.middleImage = nil;
    
    if (self.rightImage)
        self.rightImage = nil;
    
    if (!self.inputCGImage)
        return;
    
    
    //self.width = CGImageGetWidth(self.inputCGImage);
    //self.height = CGImageGetHeight(self.inputCGImage);
    
    //CGRect leftImgFrame = CGRectMake(0, 0, self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height);
    //CGRect middleImgFrame = CGRectMake(self.splitCropView.frame.size.width/3, 0, self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height);
    //CGRect rightImgFrame = CGRectMake(2*self.splitCropView.frame.size.width/3, 0, self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height);
    
    CGFloat width = xAspect * self.splitCropView.frame.size.width/3;//CGImageGetWidth(self.inputCGImage);
    CGFloat height = yAspect * self.splitCropView.frame.size.height;//CGImageGetHeight(self.inputCGImage);
    
    CGFloat x = xAspect * xMove;
    
    CGFloat y;
    
    if (yMove > 0)
        y = (self.imageView.frame.size.height - yMove) * yAspect;
    
    else if (yMove < 0)
        y = (0 - yMove) * yAspect;
    
    //CGFloat y = yAspect * yMove;
    
    CGRect leftImgFrame = CGRectMake(x, y, width, height);
    CGRect middleImgFrame = CGRectMake(x + width, y, width, height);
    CGRect rightImgFrame = CGRectMake(x + 2*width, y, width, height);
    
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(self.splitCropView.frame.origin.x, 0.0 , self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height)];
    leftButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.splitCropView addSubview:leftButton];
    [leftButton setTitle:@"3" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *middleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.splitCropView.frame.size.width/3, 0.0, self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height)];
    middleButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];;
    [self.splitCropView addSubview:middleButton];
    [middleButton setTitle:@"2" forState:UIControlStateNormal];
    [middleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(middleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(2*self.splitCropView.frame.size.width/3, 0.0, self.splitCropView.frame.size.width/3, self.splitCropView.frame.size.height)];
    rightButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    [self.splitCropView addSubview:rightButton];
    [rightButton setTitle:@"1" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGImageRef left = CGImageCreateWithImageInRect(self.inputCGImage, leftImgFrame);
    CGImageRef middle = CGImageCreateWithImageInRect(self.inputCGImage, middleImgFrame);
    CGImageRef right = CGImageCreateWithImageInRect(self.inputCGImage, rightImgFrame);
    
    self.leftImage = [UIImage imageWithCGImage:left];
    self.middleImage = [UIImage imageWithCGImage:middle];
    self.rightImage = [UIImage imageWithCGImage:right];
    
    
    CGImageRelease(left);
    CGImageRelease(middle);
    CGImageRelease(right);
    CGImageRelease(self.inputCGImage);
    
}

- (IBAction)clearButtonTapped:(id)sender {
    [self.view bringSubviewToFront:self.topScrollView];
    [self.view bringSubviewToFront:self.navHeader];
    [self.view bringSubviewToFront:self.tabBarView];

    self.splitCropView.userInteractionEnabled = NO;
    
    self.exportButton.enabled = YES;
    self.fillButton.enabled = YES;
    self.straightenButton.enabled = YES;
    self.topScrollView.userInteractionEnabled = YES;
    
    self.clearButton.hidden = YES;
    
    self.leftImage = nil;
    self.middleImage = nil;
    self.rightImage = nil;
    
    NSArray *viewsToRemove = [self.splitCropView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)leftButtonTapped:(UIButton*)sender {
    //[self writeMetadataToCreatedImage:self.leftImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //UIImageWriteToSavedPhotosAlbum(self.leftImage, nil, nil, nil);
        //[UIImagePNGRepresentation(self.leftImage) writeToFile:[self pathForPanolsDirectory:[self dateString]] atomically:YES];
        [self saveImageToPanolsGallery:self.leftImage];
        UIButton* myButton = (UIButton*)sender;
        [sender setTitle:@"Saved" forState:UIControlStateNormal];
    });
    //[self shareOnInstagram:self.leftImage];
}

- (IBAction)middleButtonTapped:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //UIImageWriteToSavedPhotosAlbum(self.middleImage, nil, nil, nil);
        //[UIImagePNGRepresentation(self.middleImage) writeToFile:[self pathForPanolsDirectory:[self dateString]] atomically:YES];
        [self saveImageToPanolsGallery:self.middleImage];
        UIButton* myButton = (UIButton*)sender;
        [myButton setTitle:@"Saved" forState:UIControlStateNormal];
    });
    //[self shareOnInstagram:self.middleImage];
}

- (IBAction)rightButtonTapped:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //UIImageWriteToSavedPhotosAlbum(self.rightImage, nil, nil, nil);
        //[UIImagePNGRepresentation(self.rightImage) writeToFile:[self pathForPanolsDirectory:[self dateString]] atomically:YES];
        [self saveImageToPanolsGallery:self.rightImage];
        UIButton* myButton = (UIButton*)sender;
        [myButton setTitle:@"Saved" forState:UIControlStateNormal];
    });
    //[self shareOnInstagram:self.rightImage];
}

- (NSString *)pathForPanolsDirectory:(NSString *)fileName {
    //    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    //                                                                        NSUserDomainMask,
    //                                                                        YES) lastObject];
    //    NSString *panolsPhotoFolder = [documentsDirectory stringByAppendingPathComponent:@"/Panols"];
    //
    //    // Create the folder if necessary
    //    BOOL isDir = NO;
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //    if (![fileManager fileExistsAtPath:panolsPhotoFolder
    //                           isDirectory:&isDir] && isDir == NO) {
    //        [fileManager createDirectoryAtPath:panolsPhotoFolder
    //               withIntermediateDirectories:NO
    //                                attributes:nil
    //                                     error:nil];
    //    }
    //    return panolsPhotoFolder;
    
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --

-(void)saveImageToPanolsGallery:(UIImage*)image{
    __block BOOL retStat = false;
    NSString *albumName = @"Panols Gallery";
    NSData *newImageSize = UIImageJPEGRepresentation(image, 1);
    UIImage *imageNew = [UIImage imageWithData:newImageSize];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHFetchResult *photosAsset;
        PHAssetCollection *collection = [self findAlbumAssetCollection:albumName];
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


-(PHAssetCollection*)findAlbumAssetCollection:(NSString*)albumName{
    PHAssetCollection *collection;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", albumName];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    return collection;
}

@end
