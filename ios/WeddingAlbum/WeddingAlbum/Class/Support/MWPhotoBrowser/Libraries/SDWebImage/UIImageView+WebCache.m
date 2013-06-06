/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
}

- (void)setReloadImageIfFailedWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholder{
    __weak UIImageView *weakImgView = self;
    [self setImageWithURL:[NSURL URLWithString:url]
            placeholderImage:placeholder
                     success:^(UIImage *image) {
                         weakImgView.image = image;
                     } failure:^(NSError *error) {
                         NSURL *URL = [NSURL URLWithString:url];
                         NSString *host = [URL host];
                         
                         NSString *optionServer = CONFIG(KeyOptionServer);
                         if ([optionServer hasPrefix:@"http://"] && optionServer.length>7) {
                             optionServer = [optionServer substringWithRange:NSMakeRange(7, optionServer.length-7)];
                         }
                         
                         NSString *url = [URL absoluteString];
                         NSMutableString *muUrl = [NSMutableString stringWithString:url];
                         [muUrl replaceOccurrencesOfString:host withString:optionServer options:0 range:NSMakeRange(0, url.length)];
                         
                         [weakImgView setImageWithURL:[NSURL URLWithString:muUrl]
                                              success:^(UIImage *image) {
                                                  weakImgView.image = image;
                                              } failure:^(NSError *error) {
                                                  weakImgView.image = nil;
                                              }];
                     }];
}

@end
