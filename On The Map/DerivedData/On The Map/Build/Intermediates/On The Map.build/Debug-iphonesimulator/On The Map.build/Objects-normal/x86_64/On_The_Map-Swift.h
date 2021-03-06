// Generated by Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import FBSDKLoginKit;
@import CoreLocation;
@import MapKit;
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;
@class NSURL;

SWIFT_CLASS("_TtC10On_The_Map11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (BOOL)application:(UIApplication * __nonnull)application openURL:(NSURL * __nonnull)url sourceApplication:(NSString * __nullable)sourceApplication annotation:(id __nonnull)annotation;
- (void)applicationWillResignActive:(UIApplication * __nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * __nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * __nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * __nonnull)application;
- (void)applicationWillTerminate:(UIApplication * __nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UdacityClient;
@class ParseClient;
@class FBSDKLoginButton;
@class FBSDKLoginManagerLoginResult;
@class NSError;
@class UITextField;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC10On_The_Map19LoginViewController")
@interface LoginViewController : UIViewController <FBSDKLoginButtonDelegate>
@property (nonatomic, readonly, strong) UdacityClient * __nonnull clientInstance;
@property (nonatomic, readonly, strong) ParseClient * __nonnull parseInstance;
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified usernameField;
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified passwordField;
@property (nonatomic, weak) IBOutlet FBSDKLoginButton * __null_unspecified facebookLoginButton;
- (void)viewDidLoad;
- (IBAction)signUpButton:(id __nonnull)sender;
- (IBAction)loginButtonPressed:(id __nonnull)sender;
- (void)loginUser;
- (void)completeLogin;
- (void)loginButton:(FBSDKLoginButton * __null_unspecified)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult * __null_unspecified)result error:(NSError * __null_unspecified)error;
- (void)loginButtonDidLogOut:(FBSDKLoginButton * __null_unspecified)loginButton;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;
@class CLGeocoder;
@class UIButton;
@class CLPlacemark;
@class UILabel;
@class MKMapView;
@class UIView;

SWIFT_CLASS("_TtC10On_The_Map11MapGeoCoder")
@interface MapGeoCoder : UIViewController <CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified streetNameField;
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified cityNameField;
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified countryNameField;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified locationPromptView;
@property (nonatomic, weak) IBOutlet MKMapView * __null_unspecified mapView;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified fetchLocationButton;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified mediaUrlPromptLabel;
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified mediaUrlField;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified submitLocationButton;
@property (nonatomic, weak) IBOutlet UIView * __null_unspecified mediaUrlView;
@property (nonatomic, readonly, strong) UdacityClient * __nonnull udacityInstance;
@property (nonatomic, readonly, strong) ParseClient * __nonnull parseInstance;
@property (nonatomic, copy) NSString * __nonnull mapString;
@property (nonatomic, strong) NSNumber * __nonnull userLat;
@property (nonatomic, strong) NSNumber * __nonnull userLon;
@property (nonatomic, readonly, strong) CLGeocoder * __nonnull geocoder;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (IBAction)cancelButtonPressed:(UIButton * __nonnull)sender;
- (IBAction)fetchLocationPrssed:(UIButton * __nonnull)sender;
- (void)delay:(double)delay closure:(void (^ __nonnull)(void))closure;
- (IBAction)submitLocationPressed:(UIButton * __nonnull)sender;
- (void)zoomInLocation:(CLPlacemark * __nonnull)placeMark;
- (IBAction)cancelMediaUrlPressed:(UIButton * __nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@protocol MKAnnotation;
@class MKAnnotationView;
@class UIControl;
@class UIBarButtonItem;
@class NSString;

SWIFT_CLASS("_TtC10On_The_Map17MapViewController")
@interface MapViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, readonly, strong) UdacityClient * __nonnull udacityInstance;
@property (nonatomic, readonly, strong) ParseClient * __nonnull parseInstance;
+ (BOOL)facebookLogin;
+ (void)setFacebookLogin:(BOOL)value;
@property (nonatomic, weak) IBOutlet MKMapView * __null_unspecified mapView;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (MKAnnotationView * __null_unspecified)mapView:(MKMapView * __nonnull)mapView viewForAnnotation:(id <MKAnnotation> __nonnull)annotation;
- (void)mapView:(MKMapView * __nonnull)mapView annotationView:(MKAnnotationView * __nonnull)annotationView calloutAccessoryControlTapped:(UIControl * __nonnull)control;
- (void)retrieveStudentLocations;
- (void)postNewPinButton;
- (void)refreshData;
- (IBAction)logoutButton:(UIBarButtonItem * __nonnull)sender;
- (BOOL)validateUrl:(NSString * __nonnull)stringURL;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSNumber (SWIFT_EXTENSION(On_The_Map))
@property (nonatomic, readonly) BOOL isBool;
@end

@class NSURLSession;
@class NSURLSessionDataTask;

SWIFT_CLASS("_TtC10On_The_Map11ParseClient")
@interface ParseClient : NSObject
@property (nonatomic, readonly, strong) NSURLSession * __nonnull session;
@property (nonatomic, copy) NSString * __nonnull userID;
- (NSURLSessionDataTask * __nonnull)taskForGetMethod:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
- (NSURLSessionDataTask * __nonnull)taskForPOSTMethod:(NSDictionary<NSString *, id> * __nonnull)jsonBody completionHandler:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
- (NSURLSessionDataTask * __nonnull)taskForQueryMethod:(NSString * __nonnull)uniqueKey completionHandler:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
- (NSURLSessionDataTask * __nonnull)taskForPutMethod:(NSString * __nonnull)objectID jsonBody:(NSDictionary<NSString *, id> * __nonnull)jsonBody completionHandler:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
+ (NSString * __nonnull)escapedParameters:(NSDictionary<NSString *, id> * __nonnull)parameters;
+ (NSString * __nullable)subtituteKeyInMethod:(NSString * __nonnull)method key:(NSString * __nonnull)key value:(NSString * __nonnull)value;
+ (ParseClient * __nonnull)sharedInstance;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface ParseClient (SWIFT_EXTENSION(On_The_Map))
- (void)getStudentLocations:(void (^ __nonnull)(BOOL, NSArray<NSDictionary<NSString *, id> *> * __nonnull, NSString * __nullable))completionHandler;
- (void)postStudentLocation:(NSString * __nonnull)uniqueKey firstName:(NSString * __nonnull)firstName lastName:(NSString * __nonnull)lastName mapString:(NSString * __nonnull)mapString mediaURL:(NSString * __nonnull)mediaURL latitude:(NSNumber * __nonnull)latitude longitude:(NSNumber * __nonnull)longitude completionHandler:(void (^ __nonnull)(BOOL, NSString * __nonnull))completionHandler;
- (void)queryExistingLocation:(NSString * __nonnull)userId completionHandler:(void (^ __nonnull)(NSString * __nullable, NSString * __nonnull))completionHandler;
- (void)updateStudentLocation:(NSString * __nonnull)objectId uniqueKey:(NSString * __nonnull)uniqueKey firstName:(NSString * __nonnull)firstName lastName:(NSString * __nonnull)lastName mapString:(NSString * __nonnull)mapString mediaURL:(NSString * __nonnull)mediaURL latitude:(NSNumber * __nonnull)latitude longitude:(NSNumber * __nonnull)longitude completionHandler:(void (^ __nonnull)(BOOL, NSString * __nonnull))completionHandler;
@end


@interface ParseClient (SWIFT_EXTENSION(On_The_Map))
@end

@class UITableView;
@class NSIndexPath;
@class UITableViewCell;

SWIFT_CLASS("_TtC10On_The_Map22PinTableViewController")
@interface PinTableViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * __null_unspecified tableView;
@property (nonatomic, readonly, strong) UdacityClient * __nonnull udacityInstance;
@property (nonatomic, readonly, strong) ParseClient * __nonnull parseInstance;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView * __nonnull)tableView;
- (void)tableView:(UITableView * __nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (void)postNewPinButton;
- (void)refreshData;
- (BOOL)validateUrl:(NSString * __nonnull)stringURL;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSData;

SWIFT_CLASS("_TtC10On_The_Map13UdacityClient")
@interface UdacityClient : NSObject
@property (nonatomic, strong) NSURLSession * __nonnull session;
@property (nonatomic, copy) NSString * __nullable userID;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (NSURLSessionDataTask * __nonnull)taskForLogin:(NSDictionary<NSString *, id> * __nonnull)jsonBody completionHandler:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
- (void)taskForLogout;
- (NSURLSessionDataTask * __nonnull)taskForGetUserData:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
+ (void)parseJSONWithCompletionHandler:(NSData * __nonnull)data completionHandler:(void (^ __nonnull)(id __null_unspecified, NSError * __nullable))completionHandler;
+ (NSString * __nullable)subtituteKeyInMethod:(NSString * __nonnull)method key:(NSString * __nonnull)key value:(NSString * __nonnull)value;
+ (UdacityClient * __nonnull)sharedInstance;
@end


@interface UdacityClient (SWIFT_EXTENSION(On_The_Map))
- (void)authenticateWithViewController:(UIViewController * __nonnull)hostViewController username:(NSString * __nonnull)username password:(NSString * __nonnull)password completionHandler:(void (^ __nonnull)(BOOL, NSString * __nullable))completionHandler;
- (void)loginWithInfoWithUsername:(NSString * __nullable)username password:(NSString * __nullable)password completionHandler:(void (^ __nonnull)(BOOL, NSString * __nullable))completionHandler;
@end


@interface UdacityClient (SWIFT_EXTENSION(On_The_Map))
@end

#pragma clang diagnostic pop
