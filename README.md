Jayson
------

Jayson is an Objective-C JSON Library with the aim to provide simple serialization/deserialization 
for complex types, arrays and value types.

To serialize an object, simply use [JYJayson serializeObject:]

```objc
Book *book = [Book new];
book.title = @"The Hitchhiker's Guide to the Galaxy";
book.publishedDate = [NSDate dateWithTimeIntervalSince1970:308534400] // Fri, 12 Oct 1979
book.genres = @[@"Comedy",@"Science-Fiction"];

NSString *serialized = [JYJayson serializeObject:book];
//{
//  "title":"The Highthiker's Guide to the Galaxy",
//  "publishedDate":"1979-10-12T00:00:00Z",
//  "genres":[
//    "Comedy",
//    "Science-Fiction"
//  ]
//}
```

You can also deserialize a json string using [JYJayson deserializeObject:withClass:]

```objc
NSString *json = @"{\"title\":\"The Highthiker's Guide to the Galaxy\",\
                  \"publishedDate\":\"1979-10-12T00:00:00Z\",\
                  \"genres\":[\"Comedy\",\"Science-Fiction\"]}";

Book *book = [JYJayson deserializeObject:json withClass:[Book class]];
```
