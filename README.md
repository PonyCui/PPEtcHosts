# PPEtcHosts

This PPEtcHosts use another implementation way, thanks for [Mattt Thompson](http://github.com/mattt).

This PPEtcHosts gives you the whole application host name controls. It effects UIWebView/NSURLConnection/NSURLSession etc.

Because all this library depends NSURLRequest.

One More Thing! AFNetworking, SDWebImage is also available.

PonyCui/PPEtcHosts uses `NSURLRequest`, swizzling init method.

> This is a proof-of-concept, and is not intended for use in production. It's not safe use in prodution. For safely, all code use DEBUG marcos to prevent NSEtcHosts Class build in prodution.

## Install

add "src" files to your project.

## Usage

```objective-c
#import "NSEtcHosts.h"
#ifdef DEBUG
    [NSEtcHosts addHost:@"www.github.com" ipAddress:@"210.38.111.228"];
#endif
```

```objective-c
NSURL *URL = [NSURL URLWithString:@"http://www.github.com"];
[webView loadRequest:[NSURLRequest requestWithURL:URL]];
```

```objective-c
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.github.com"]];
[NSURLConnection sendAsynchronousRequest:request
                                   queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
}];
```

## Contact

[Pony Cui](http://github.com/ponycui)

## License

PPEtcHosts is available under the MIT license. See the LICENSE file for more info.
