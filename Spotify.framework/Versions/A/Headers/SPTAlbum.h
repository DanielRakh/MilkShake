//
//  SPTAlbum.h
//  Basic Auth
//
//  Created by Daniel Kennett on 19/11/2013.
/*
 Copyright 2013 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "SPTJSONDecoding.h"
#import "SPTRequest.h"
#import "SPTTypes.h"

@class SPTPartialArtist;

/** This class represents an album on the Spotify service. */
@interface SPTAlbum : NSObject <SPTJSONObject, SPTTrackProvider>

/** Request the album at the given Spotify URI.

 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.

 @param uri The Spotify URI of the album to request.
 @param session An authenticated session. Can be `nil`.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)albumWithURI:(NSURL *)uri session:(SPTSession *)session callback:(SPTRequestCallback)block;

/** The name of the album. */
@property (nonatomic, readonly, copy) NSString *name;

/** The Spotify URI of the album. */
@property (nonatomic, readonly, copy) NSURL *uri;

/** Any external IDs of the album, such as the UPC code. */
@property (nonatomic, readonly, copy) NSDictionary *externalIds;

/** An array of ISO 3166 country codes in which the album is available. */
@property (nonatomic, readonly, copy) NSArray *availableTerritories;

/** The artist of this album. */
@property (nonatomic, readonly) SPTPartialArtist *artist;

/** An array of tracks contained by this album, as `SPTPartialTrack` objects. */
@property (nonatomic, readonly, copy) NSArray *tracks;

/** The release year of the album if known, otherwise `0`. */
@property (nonatomic, readonly) NSInteger releaseYear;

@end
