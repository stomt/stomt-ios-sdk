//
//  STImage.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 16/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "block_declarations.h"

@class UIImage;

/*!
 * STImage represents any kind of image from the stomt api.
 */
@interface STImage : NSObject


/*!
* @brief The actual image.
*/
@property (nonatomic,strong) UIImage* image;

/*!
 * @brief The image name, associated with the image on the stomt servers.
 */
@property (nonatomic,strong) NSString* imageName;

/*!
 * @brief The image URL on the stomt servers.
 */
@property (nonatomic,strong) NSURL* url;

/*!
 * @brief Creates STImage instance by providing the image name.
 *
 * @params name
 *
 * @return Newly created UIImage instance.
 */
- (instancetype)initWithStomtImageName:(NSString *)name;

/*!
 * @brief
 *
 * @params imageUrl
 *
 * @return Newly created UIImage instance.
 */
- (instancetype)initWithUrl:(NSURL*)imageUrl;

/*!
 * @brief Asynchronously download the image.
 *
 * @param The completion block to be called after the download process is completed.
 */
- (void)downloadInBackgroundWithBlock:(BooleanCompletion)completion;

@end
