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

#import <Foundation/Foundation.h>

#import <simd/simd.h>

/** Possible values of GARAnchor.cloudState. */
typedef NS_ENUM(NSInteger, GARCloudAnchorState) {
  /** There has not been an attempt to host or resolve this anchor. */
  GARCloudAnchorStateNone = 0,
  /** This anchor has started the process of hosting or resolving, but it is not complete. */
  GARCloudAnchorStateTaskInProgress = 1,
  /**
   * This anchor has been hosted or has resolved successfully. The cloudIdentifier property should
   * now be valid.
   */
  GARCloudAnchorStateSuccess = 2,
  /** Internal error. No recommended mitigation. */
  GARCloudAnchorStateErrorInternal = -1,
  /** The app can't communicate with the cloud service due to a bad API key. */
  GARCloudAnchorStateErrorNotAuthorized = -2,
  /**
   * The ARCore Cloud Anchor service was unreachable. This can happen because of a number of
   * reasons. A request sent to the server could have timed out with no response, there could be a
   * bad network connection, DNS unavailability, firewall issues, or anything that could affect the
   * device's ability to connect to the ARCore Cloud Anchor service.
   */
  GARCloudAnchorStateErrorServiceUnavailable = -3,
  /**
   * The application has exhausted the request quota allotted to its Google Cloud project. The
   * developer should request additional quota for the project from the Google Developers Console.
   */
  GARCloudAnchorStateErrorResourceExhausted = -4,
  /**
   * Hosting failed, because the server could not successfully process the dataset for the given
   * anchor. The developer should try again after the device has gathered more data from the
   * environment.
   */
  GARCloudAnchorStateErrorHostingDatasetProcessingFailed = -5,
  /**
   * Resolving failed, because the ARCore Cloud Anchor service could not find the provided cloud
   * anchor ID.
   */
  GARCloudAnchorStateErrorCloudIdNotFound = -6,
  /**
   * The server could not match the visual features provided by ARCore against the localization
   * dataset of the requested cloud anchor ID. This means that the anchor being requested was likely
   * not created in the user's surroundings.
   */
  GARCloudAnchorStateErrorResolvingLocalizationNoMatch = -7,
  /**
   * The anchor could not be resolved because the SDK used to host the anchor was newer than and
   * incompatible with this one.
   */
  GARCloudAnchorStateErrorResolvingSdkVersionTooOld = -8,
  /**
   * The anchor could not be resolved because the SDK used to host the anchor was older than and
   * incompatible with this one.
   */
  GARCloudAnchorStateErrorResolvingSdkVersionTooNew = -9
};

NS_ASSUME_NONNULL_BEGIN

/**
 * ARCore anchor class. May represent a cloud anchor. A GARAnchor is an immutable snapshot of an
 * underlying anchor at a particular timestamp. All snapshots of the same underlying anchor will
 * have the same identifier.
 */
@interface GARAnchor : NSObject <NSCopying>

/**
 * Transform of anchor relative to world origin. This should only be considered valid if the
 * property hasValidTransform returns YES.
 */
@property(nonatomic, readonly) matrix_float4x4 transform;

/**
 * Unique Identifier for this anchor. |isEqual:| will return YES for another GARAnchor with the same
 * identifier, and the |hash| method is also computed from the identifier.
 */
@property(nonatomic, readonly) NSUUID *identifier;

/**
 * Cloud anchor identifier. This will be nil unless the cloud state of the anchor is
 * GARCloudAnchorStateSuccess.
 */
@property(nonatomic, readonly, nullable) NSString *cloudIdentifier;

/**
 * Whether or not this anchor has a valid transform.
 */
@property(nonatomic, readonly) BOOL hasValidTransform;

/**
 * The cloud anchor state. Indicates the state of the hosting or resolving operation on this anchor,
 * if any.
 */
@property(nonatomic, readonly) GARCloudAnchorState cloudState;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
