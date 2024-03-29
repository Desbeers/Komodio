#  Komodio

## A macOS, tvOS, iPadOS and visionOS Video Client for [Kodi](https://kodi.tv)

![Icon](https://github.com/Desbeers/Komodio/raw/main/Images/icon.png)

**Komodio** is a video player for tvOS 17, macOS Sonoma, iPadOS 17 and visionOS that can stream videos from your local Kodi host.

![Komodio](https://github.com/Desbeers/Komodio/raw/main/Images/screenshot-macOS.jpg)

It is a simple player and does not have all the 'bells and whistles' that the *real* Kodi has. Kodi will never be available for tvOS, however, Komodio will let you play your media on it. Good enough for me.

Kodi is available on *macOS*. But it's not a *Mac* application.

While *tvOS* and *macOS* are vastly different when it comes to the user interface; they both share `Swift` and `SwiftUI`. They also both share the fact that they are the most neglected platforms in the *Apple World*. A challenge!

**Komodio** is the perfect example for an *multi-platform* application. Most of the code is shared while each platform has its own behaviour.

- It battles the *Siri Remote* on tvOS
- It fights with `SwiftUI` on macOS

I'm proud of it!

### Release (Appstore)

I have no intention to make a **Komodio** release here on GitHub or on the Apple Stores. It is just `source code`. 'You're on your own, kid', to quote *Taylor Swift*.

### Bugs & Limitations

- Because it's an `Apple` client using AVkit, it can only play Quicktime compatible files. So, **no MKV's**...
- Komodio depends on Bonjour to find your Kodi hosts.
- If your media is on a harddisk and it's sleeping; the media wil sometimes not start because of a timeout. Try again and it will work. I don't know how to fix that yet...
- Other bugs are free without an in-app purchase (IAP)

## Dependencies

**Komodio** depends on the following Swift Package that is in my GitHub account:

- [SwiftlyKodiAPI](https://github.com/Desbeers/swiftlykodiapi). The Swift API to talk to Kodio.

## Code documentation

The source code of **Komodio** is well [documented](https://desbeers.github.io/Komodio/).

## What's in a name?

***Komodio** has no meaning. I wrote an audio remote application for Kodi named [Kodio](https://github.com/Desbeers/Kodio/), so wanted something similar..

## How to compile

Xcode 15 is required.

1. Clone the project
2. Change the signing certificate to your own
2. Build and run!
