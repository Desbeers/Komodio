#  Komodio

## An `Apple` Video Client for  [Kodi](https://kodi.tv)

Komodio is a video player for macOS, iPadOS and tvOS that can stream videos from your local Kodi host.

### Limitations

It is all very much work in progress...

- Because it's an `Apple` client using AVkit, it can only play Quicktime compatible files. So, no mkv's...
- The 'Kodi login' configuration is currently hardcoded in the ``AppState.swift`` file.

## Dependencies

Komodio depends on the following Swift Packages that are in my GitHub account:

- [SwiftlyKodiAPI](https://github.com/Desbeers/swiftlykodiapi/). The Swift API to talk to Kodio. 
- [SwiflyStackNavigation](https://github.com/Desbeers/swiftlystacknavigation/). Stack navigation for macOS.

Both packages are specially written for Komodio and also still very, very much work in progress.

## What's in a name?

*Komodio* has no meaning. I wrote an audio remote application for Kodi named [Kodio](https://github.com/Desbeers/Kodio/), so wanted something similar..

## How to compile

1. Clone the project.
2. Change the signing certificate to your own.
2. Build and run!
