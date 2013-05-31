//
//  MWPhoto.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

// Private
@interface MWPhoto () {
    // Image Sources
    NSString *_photoPath;
    NSURL *_photoURL;

    NSURL *_photoOptionURL;
    
    // Image
    UIImage *_underlyingImage;

    // Other
    NSString *_caption;
    BOOL _loadingInProgress;       
}

// Methods
- (void)imageDidFinishLoadingSoDecompress;
- (void)imageLoadingComplete;

@end

// MWPhoto
@implementation MWPhoto

// Properties
@synthesize underlyingImage = _underlyingImage,
caption = _caption,
isLoading = _isLoading;

#pragma mark Class Methods

+ (MWPhoto *)photoWithImage:(UIImage *)image {
	return [[[MWPhoto alloc] initWithImage:image] autorelease];
}

+ (MWPhoto *)photoWithFilePath:(NSString *)path {
	return [[[MWPhoto alloc] initWithFilePath:path] autorelease];
}

+ (MWPhoto *)photoWithURL:(NSURL *)url {
	return [[[MWPhoto alloc] initWithURL:url] autorelease];
}

#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
	if ((self = [super init])) {
		self.underlyingImage = image;
	}
	return self;
}

- (id)initWithFilePath:(NSString *)path {
	if ((self = [super init])) {
		_photoPath = [path copy];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_photoURL = [url copy];
	}
	return self;
}

- (void)dealloc {
    [_caption release];
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
	[_photoPath release];
	[_photoURL release];
	[_underlyingImage release];
	[super dealloc];
}

#pragma mark MWPhoto Protocol Methods

- (BOOL)isSuccessLoad{
    return _underlyingImage && self.success;
}

- (BOOL)isLoading{
    return _isLoading;
}

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify {
    _isLoading = NO;
    
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    _loadingInProgress = YES;
    if (self.underlyingImage) {
        // Image already loaded
        [self imageLoadingComplete];
    } else {
        if (_photoPath) {
            // Load async from file
            [self performSelectorInBackground:@selector(loadImageFromFileAsync) withObject:nil];
        } else if (_photoURL) {
            _isLoading = YES;
            // Load async from web (using SDWebImage)
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:(_photoOptionURL?_photoOptionURL:_photoURL) delegate:self];
        } else {
            // Failed - no source
            self.underlyingImage = nil;
            [self imageLoadingComplete];
        }
    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _isLoading = NO;
    
    _loadingInProgress = NO;
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
	if (self.underlyingImage && (_photoPath || _photoURL)) {
		self.underlyingImage = nil;
	}
}

#pragma mark - Async Loading

// Called in background
// Load image in background from local file
- (void)loadImageFromFileAsync {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    @try {
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:_photoPath options:NSDataReadingUncached error:&error];
        if (!error) {
            self.underlyingImage = [[[UIImage alloc] initWithData:data] autorelease];
        } else {
            self.underlyingImage = nil;
            MWLog(@"Photo from file error: %@", error);
        }
    } @catch (NSException *exception) {
    } @finally {
        [self performSelectorOnMainThread:@selector(imageDidFinishLoadingSoDecompress) withObject:nil waitUntilDone:NO];
        [pool drain];
    }
}

// Called on main
- (void)imageDidFinishLoadingSoDecompress {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.underlyingImage) {
        // Decode image async to avoid lagging when UIKit lazy loads
        [[SDWebImageDecoder sharedImageDecoder] decodeImage:self.underlyingImage withDelegate:self userInfo:nil];
    } else {
        // Failed
        [self imageLoadingComplete];
    }
}

- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

#pragma mark - SDWebImage Delegate

// Called on main
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    _isLoading = NO;
    self.underlyingImage = image;
    [self imageDidFinishLoadingSoDecompress];
    
    _photoOptionURL = nil;
    self.success = YES;
}

// Called on main
- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error {
    _isLoading = NO;
    
    if (_photoOptionURL) { //done with failure
        [_photoOptionURL release]; _photoOptionURL = nil;
        
        self.underlyingImage = nil;
        MWLog(@"SDWebImage failed to download image: %@", error);
        [self imageDidFinishLoadingSoDecompress];
        
        self.underlyingImage = [UIImage imageNamed:@"bg_nopic.png"];
        self.success = NO;
    }else{//user option server to download picture again;
        NSString *host = [_photoURL host];
        
        NSString *optionServer = CONFIG(KeyOptionServer);
        if ([optionServer hasPrefix:@"http://"] && optionServer.length>7) {
            optionServer = [optionServer substringWithRange:NSMakeRange(7, optionServer.length-7)];
        }
        
        NSString *url = [_photoURL absoluteString];
        NSMutableString *muUrl = [NSMutableString stringWithString:url];
        [muUrl replaceOccurrencesOfString:host withString:optionServer options:0 range:NSMakeRange(0, url.length)];
        
        _photoOptionURL = nil;
        _photoOptionURL = [[NSURL URLWithString:muUrl] copy];
        
        [self loadUnderlyingImageAndNotify];
    }
}

// Called on main
- (void)imageDecoder:(SDWebImageDecoder *)decoder didFinishDecodingImage:(UIImage *)image userInfo:(NSDictionary *)userInfo {
    _isLoading = NO;
    
    // Finished compression so we're complete
    self.underlyingImage = image;
    [self imageLoadingComplete];
    
    if (image) {
        self.success = YES;
    }else{
        self.underlyingImage = [UIImage imageNamed:@"bg_nopic.png"];
        self.success = NO;
    }
}

@end
