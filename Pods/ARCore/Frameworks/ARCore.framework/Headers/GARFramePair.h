/*
 * Copyright 2018 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <ARKit/ARKit.h>

@class GARFrame;

NS_ASSUME_NONNULL_BEGIN

/**
 * Container class for an ARFrame and its corresponding GARFrame. These two frames will always have
 * the same timestamp. GARFrame's do not hold references to ARFrame's - ARFrame's must be released
 * as quickly as possible to free up resources, or ARKit may be starved. The SDK only holds a
 * reference to the most recent frame pair.
 */
@interface GARFramePair : NSObject

@property(nonatomic, readonly) ARFrame *arFrame;
@property(nonatomic, readonly) GARFrame *garFrame;

- (instancetype _Nullable)initWithARFrame:(ARFrame *)arFrame
                                 GARFrame:(GARFrame *)garFrame;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
