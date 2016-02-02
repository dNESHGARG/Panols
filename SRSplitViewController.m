//
//  SRSplitViewController.m
//  Splitarama
//
//  Created by Dinesh Garg on 2/2/16.
//  Copyright © 2016 Panols. All rights reserved.
//

#import "SRSplitViewController.h"
#import "SRImageMetadata.h"

@interface SRSplitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGImageRef inputCGImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation SRSplitViewController

- (instancetype)initWithWithData:(SRImageMetadata*)metaData andCGImage:(CGImageRef)cgImage; {
    self = [super init];
    
    if (self != nil)
    {
        self.inputCGImage = cgImage;
        self.image = metaData.image;
    }
    
    return self;
}

- (void)dealloc{
    CFRelease(self.inputCGImage);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.imageView.image = self.image;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --

- (IBAction)backButtontapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)straightenButtonTapped:(id)sender {
}

- (IBAction)fillButtonTapped:(id)sender {
}

- (IBAction)exportButtonTapped:(id)sender {
}

#pragma mark --

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
