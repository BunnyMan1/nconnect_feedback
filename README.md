<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

Carrier metadata uses `carrier_info_plus`. Host apps need Android API 24+.
On Android, declare and grant `READ_PHONE_STATE` to include subscription details;
without it, the plugin returns the available permission-free subset. Feedback
collection does not request permissions itself.

The feedback JSON keeps the `phone_number`, `cell_id`, and `carrier_allows_voip`
keys, but they are always null because `carrier_info_plus` does not expose them.
`AdditionalDeviceInfo.cellId` is an `int?`. On iOS, carrier identity is
unavailable; network generation is derived from the reported radio technologies.
SIM identity uses the first slot, while network generation describes the fastest
reported device connection.

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
