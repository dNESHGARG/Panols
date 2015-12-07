//
//  SRHomwViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 10/1/15.
//  Copyright © 2015 Dinesh Garg. All rights reserved.
//

#import "SRHomeViewController.h"

@interface SRHomeViewController () <UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (weak, nonatomic) IBOutlet UIView *panelsBackgroundView;
@property (nonatomic, strong) UIImage* leftImage;
@property (nonatomic, strong) UIImage* middleImage;
@property (nonatomic, strong) UIImage* rightImage;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, assign) CGImageRef inputCGImage;

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;

@end

@implementation SRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.panelsBackgroundView.backgroundColor = [UIColor colorWithRed:242./255. green:243./255. blue:244./255. alpha:0.8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
- (IBAction)defaultButtontapped:(id)sender {
    [self splitImage];
}

- (IBAction)customButtonTapped:(id)sender {
    [self splitImage];
}

- (IBAction)galleryButtonTapped:(id)sender {
    [self selectImage];
}

# pragma mark -

-(void)splitImage
{
    UIImage *image = self.imageView.image;
    CGSize newsize = self.imageView.image.size;

    //CGImageRef inputCGImage = [image CGImage];
    self.width = CGImageGetWidth(self.inputCGImage);
    self.height = CGImageGetHeight(self.inputCGImage);
    
    CGFloat imgWidth = newsize.width/3;
    CGFloat imgheight = newsize.height;
    CGRect leftImgFrame = CGRectMake(0, 0, imgWidth, imgheight);
    CGRect middleImgFrame = CGRectMake(imgWidth, 0, imgWidth, imgheight);
    CGRect rightImgFrame = CGRectMake(2*imgWidth, 0, imgWidth, imgheight);
    
    UIView *leftView = [[UIView alloc] initWithFrame:leftImgFrame];
    //[self.imageView addSubview:leftView];
    leftView.backgroundColor = [UIColor colorWithRed:242./255. green:243./255. blue:244./255. alpha:0.8];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:leftView.frame];
    [leftView addSubview:leftButton];
    [leftButton setTitle:@"1" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *middleView = [[UIView alloc] initWithFrame:middleImgFrame];
    //[self.imageView addSubview:middleView];
    middleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIButton *middleButton = [[UIButton alloc] initWithFrame:middleView.frame];
    [middleView addSubview:middleButton];
    [middleButton setTitle:@"2" forState:UIControlStateNormal];
    [middleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [middleButton addTarget:self action:@selector(middleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:rightImgFrame];
    //[self.imageView addSubview:rightView];
    rightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:rightView.frame];
    [rightView addSubview:rightButton];
    [rightButton setTitle:@"3" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGImageRef left = CGImageCreateWithImageInRect(image.CGImage, leftImgFrame);
    CGImageRef middle = CGImageCreateWithImageInRect(image.CGImage, middleImgFrame);
    CGImageRef right = CGImageCreateWithImageInRect(image.CGImage, rightImgFrame);
    
    self.leftImage = [UIImage imageWithCGImage:left];
    self.middleImage = [UIImage imageWithCGImage:middle];
    self.rightImage = [UIImage imageWithCGImage:right];
    
    //self.imageView.image = middleImage;
    //NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    //if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    //{
    
    leftView.userInteractionEnabled = YES;
    middleView.userInteractionEnabled = YES;
    rightView.userInteractionEnabled = YES;
    leftButton.userInteractionEnabled = YES;
    
    [self.imageView bringSubviewToFront:self.shareButton];
    
    CGImageRelease(left);
    CGImageRelease(middle);
    CGImageRelease(right);
    CGImageRelease(self.inputCGImage);
    
}

- (IBAction)share:(id)sender {
    [self shareOnInstagram:self.leftImage];
}

- (void)leftButtonTapped:(UIButton*)sender {
    [self shareOnInstagram:self.leftImage];
}

- (IBAction)middleButtonTapped:(id)sender {
     [self shareOnInstagram:self.middleImage];
}

- (IBAction)rightButtonTapped:(id)sender {
     [self shareOnInstagram:self.rightImage];
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

# pragma mark -

- (void)selectImage {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = image;
        self.inputCGImage = [image CGImage];
    }];
}

@end
