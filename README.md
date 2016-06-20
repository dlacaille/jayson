![jayson logo](jayson.png)
------

jayson is an Objective-C JSON Library with the aim to provide simple serialization/deserialization 
for complex types, arrays and value types.

To serialize an object, simply use ```[JYJayson serializeObject:]```

```objc
Book *book = [Book new];
book.title = @"The Hitchhiker's Guide to the Galaxy";
book.publishedDate = [NSDate dateWithTimeIntervalSince1970:308534400] // Fri, 12 Oct 1979
book.genres = @[@"Comedy",@"Science-Fiction"];

NSString *serialized = [JYJayson serializeObject:book];
//{
//  "title": "The Hitchthiker's Guide to the Galaxy",
//  "publishedDate": "1979-10-12T00:00:00Z",
//  "genres": [
//    "Comedy",
//    "Science-Fiction"
//  ]
//}
```

You can also deserialize a json string using [JYJayson deserializeObject:withClass:]

```objc
NSString *json = @"{\"title\":\"The Hitchhiker's Guide to the Galaxy\",\
                  \"publishedDate\":\"1979-10-12T00:00:00Z\",\
                  \"genres\":[\"Comedy\",\"Science-Fiction\"]}";

Book *book = [JYJayson deserializeObject:json withClass:[Book class]];
```

Alternatively, you can deserialize to an array of a specific type with [JYJayson deserializeObjectArray:withClass:]
or a dictionary with a value of a specific type with [JYJayson deserializeObjectDictionary:withClass:]

```objc
NSString *json = @"[{\"title\":\"The Hitchhiker's Guide to the Galaxy\",\
                  \"publishedDate\":\"1979-10-12T00:00:00Z\",\
                  \"genres\":[\"Comedy\",\"Science-Fiction\"]},\
                  {\"title\":\"The Restaurant at the End of the Universe\",\
                  \"publishedDate\":\"1980-10-01T00:00:00Z\",\
                  \"genres\":[\"Comedy\",\"Science-Fiction\"]}]";

NSArray<Book *> *book = [JYJayson deserializeObjectArray:json withClass:[Book class]];
```

Any NSObject with properties can be used with Jayson.

```objc
@interface Book : NSObject
@property NSString *title;
@property NSDate *publishedDate;
@property NSArray *genres;
@end
```

Supported types
---------------

- Primitive types (int, long, short, float, double, etc)
- NSString
- NSNumber
- NSDate
- NSArray
- NSData
- NSArray
- NSDictionary
- NSObject

Types which are not supported or need to be serialized/deserialized differently can be implemented with a JYJsonConverter 
