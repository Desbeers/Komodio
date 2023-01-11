# ``KomodioTV``

An 'Apple TV' Video Client for Kodi

## Overview

Komodio is a video player for tvOS 16 that can stream videos from your local [Kodi](https://kodi.tv) host.

Most of the code is shared between the *macOS* and *tvOS* version.

**Dependencies**

Komodio depends on the following Swift Package that are in my GitHub account:

- [SwiftlyKodiAPI](https://github.com/Desbeers/swiftlykodiapi). The Swift API to talk to Kodi.

**Limitations**

- Because it's an `Apple` client using AVkit, it can only play Quicktime compatible files. So, **no MKV's**...
- Komodio depends on Bonjour to find your Kodi hosts.
- The 'Kodi login' configuration is using default settings.
- If your media is on a harddisk and it's sleeping; the media wil sometimes not start because of a timeout. Try again and it will work.
- Komodio is written in SwiftUI 4, so well, a bit buggy :-)

**What's in a name?**

*Komodio* has no meaning. I wrote an audio remote application for Kodi named [Kodio](https://github.com/Desbeers/Kodio/), so wanted something similar...

## Topics

### General

- ``KomodioApp``
- ``Router``
- ``MediaItem``

### Observable Classes

- ``AppState``
- ``SceneState``
- ``RotatingIconModel``
- ``SiriRemoteController``

### SwiftUI Views

- ``MainView``
- ``SidebarView``
- ``ContentView``
- ``DetailView``
- ``StartView``
- ``MoviesView``
- ``MovieView``
- ``MovieSetView``
- ``TVShowsView``
- ``TVShowView``
- ``SeasonsView``
- ``SeasonView``
- ``EpisodeView``
- ``UpNextView``
- ``ArtistsView``
- ``ArtistView``
- ``AlbumView``
- ``MusicVideosView``
- ``MusicVideoView``
- ``StatisticsView``
- ``KomodioPlayerView``
- ``SearchView``
- ``KodiSettingsView``
- ``Buttons``
- ``Modifiers``
- ``Parts``
- ``Styles``

