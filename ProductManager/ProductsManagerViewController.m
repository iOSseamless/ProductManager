//
//  ListViewController.m
//  ProductListManager
//
//  Created by Steve Ballmer II on 2014-06-02.
//  Copyright (c) 2014 com.megasoft.fr All rights reserved.
//

#import "ProductsManagerViewController.h"

#define kCellIdentifier            @"Cell Identifier"

@implementation ProductsManagerViewController
@synthesize images = _images;

- (NSDictionary *)images {
    
    if (!_images) {
        NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"keys" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
        NSArray *words = [fileContents componentsSeparatedByString:@"\n"];
        NSMutableDictionary* mutablePhotosDictionary = [[NSMutableDictionary alloc] init];
        for ( int i = 0; i < 100; i++) {
            [mutablePhotosDictionary setObject:@"http://lorempixel.com/200/100" forKey:[words objectAtIndex:arc4random_uniform([words count])]];
        }
        _images = [NSDictionary dictionaryWithDictionary:mutablePhotosDictionary];
    }
    return _images;
}

- (void)viewDidLoad {
    self.title = @"Products list";
    [super viewDidLoad];
}

- (void)viewDidUnload {
    self.images = nil;
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *rowKey = [[self.images allKeys] objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[self.images objectForKey:rowKey]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = nil;
    if (imageData) {
        UIImage *unfiltered_image = [UIImage imageWithData:imageData];
        image = [self applyFilterToImage:unfiltered_image];
    }
    cell.textLabel.text = rowKey;
    cell.imageView.image = image;
    
    return cell;
}

- (UIImage *)applyFilterToImage:(UIImage *)image {
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    UIImage *sepiaImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    CGImageRelease(outputImageRef);
    return sepiaImage;
}

@end