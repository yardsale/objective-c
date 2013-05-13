//
//  PNErrorCodes.h
//  pubnub
//
//  Describes all available error codes
//
//
//  Created by Sergey Mamontov on 12/5/12.
//
//


#pragma mark - Client error codes

// Unknown error
static NSInteger const kPNUnknownError = -1;

// PubNub client find out that it wasn't fully
// configured and can't process his work
static NSInteger const kPNClientConfigurationError = 100;

// PubNub client find out that it wasn't fully
// configured for publishing message
static NSInteger const kPNClientConfigurationPublishKeyError = 101;

// PubNub client tried to connect while it already
// has opened connection to PubNub services
static NSInteger const kPNClientTriedConnectWhileConnectedError = 102;

// PubNub client failed to connect to PubNub services
// because internet went down
static NSInteger const kPNClientConnectionFailedOnInternetFailureError = 103;

// PubNub client disconnected because of network issues
static NSInteger const kPNClientConnectionClosedOnInternetFailureError = 104;

// PubNub client failed to execute request because there is
// no connection which can be used to reach PubNub services
static NSInteger const kPNRequestExecutionFailedOnInternetFailureError = 105;

// PubNub client failed to execute request because of client
// not ready
static NSInteger const kPNRequestExecutionFailedClientNotReadyError = 106;

// PubNub client failed to execute request because of timeout
static NSInteger const kPNRequestExecutionFailedByTimeoutError = 107;

// PubNub client failed to use presence API because it
// is not enabled in used account
static NSInteger const kPNPresenceAPINotAvailableError = 108;

// PubNub service refuse to process request because it has
// wrong JSON format
static NSInteger const kPNInvalidJSONError = 109;

// PubNub service refuse to process request because it has
// wrong subscribe/publish key
static NSInteger const kPNInvalidSubscribeOrPublishKeyError = 110;

// PubNub service refuse to process message sending because
// it is too long
static NSInteger const kPNTooLongMessageError = 111;

// PubNub service reported that restricted characters has been
// used in channel name and request can't be processed
static NSInteger const kPNRestrictedCharacterInChannelNameError = 112;


#pragma mark - Cryptography error

// Developer tried to initalize Cryptor helper with configuraiton
// which doesn't has cipher key in it
static NSInteger const kPNCryptoEmptyCipherKeyError = 113;

// Error occured during cryptor initialization because of error
// in provided paramteres
static NSInteger const kPNCryptoIllegalInitializationParametersError = 114;

// Error occured because buffer with insufficient size was
// provided for encrypted/decrypted data output
static NSInteger const kPNCryptoInsufficentBufferSizeError = 115;

// Error occure in case if during cryptor operation there was not enough
// memory for it's operation
static NSInteger const kPNCryptoInsufficentMemoryError = 116;

// Error occured because input data wasn't properly alligned
static NSInteger const kPNCryptoAligmentInputDataError = 117;

// Error occured during input data encode/decode process
static NSInteger const kPNCryptoInputDataProcessingError = 118;

// Error occure if developer try to use one of features which is not
// available in specified algorithm
static NSInteger const kPNCryptoUnavailableFeatureError = 119;



#pragma mark - Developers error (caused by developer)

// Developer tries to submit empty (nil) request by passing
// no message object to PubNub service
static NSInteger const kPNMessageObjectError = 120;

// Developer tried to submit message w/o text to PubNub service
static NSInteger const kPNMessageHasNoContentError = 121;

// Developer tried to submit message w/o target channel to
// PubNub service
static NSInteger const kPNMessageHasNoChannelError = 122;


#pragma mark - Service error (caused by remote server)

// Server provided response which can't be decoded with UTF8
static NSInteger const kPNResponseEncodingError = 123;

// Server provided response with malformed JSON in it
// (in such casses library will try to resend request to
// remote origin)
static NSInteger const kPNResponseMalformedJSONError = 124;


#pragma mark - Connection (transport layer) error codes

// Was unable to configure connection because of some
// errors
static NSInteger const kPNConnectionErrorOnSetup = 125;