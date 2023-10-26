# Develop

This is the full guide to start developing with this plugin.

Just install the [required](#requirements) tools and make sure they work. The rest is pretty simple cause I have written an automation script to build and release. Yay.

## Table of Contents
- [Develop](#develop)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Project Structure](#project-structure)
  - [Workflow](#workflow)
    - [Android](#android)
    - [iOS](#ios)
  - [Scripts](#scripts)
    - [Android Scripts](#android-scripts)
    - [iOS Scripts](#ios-scripts)

## Requirements

> Android Plugin

- Android Studio (preferably latest) & related SDKs ([Download](https://developer.android.com))
- Java 17

> iOS Plugin

- XCode (preferably latest)
- Python 3.x - ([Install](https://docs.python-guide.org/starting/install3/osx/))
- Scon ([Install](https://scons.org/doc/production/HTML/scons-user/ch01s02.html))


## Project Structure

```
.
└── root/
    ├── android/        - Android plugin
    ├── ios/            - iOS plugin
    ├── autoload/       - Autoload files to load Singleton plugin
    ├── scripts/        - Scripts to install, build, and release for Android/iOS
    ├── example/        - Examples for testing
    ├── .cache/         - Cache folder to download building templates and headers
    ├── .release/       - When release a plugin, it will be here
    └── build.env       - The plugin's build enviroment
```

## Workflow

### Android

Make sure you have opened the example (Godot 3 or 4 based on your preference).

Install Android Custom Template (So that there will be `android/plugins` folder)

Code the Android plugin in `./android` folder

Then run:

```sh
./scripts/android/build <version>
```

The plugin will be built and also copied to `example/`. And you are now ready to test it :)

(Make sure the plugin is checked in Android export preset)

### iOS

Code iOS plugin in `./ios` folder

Then run:

```sh
./scripts/android/build <version>
```

The plugin will be built and also copied to `example/`.

Just export the iOS project (make sure the plugin is checked in iOS export preset)

And done, everything is ready for testing :)

## Scripts

### Android Scripts

> [install.sh](./scripts/android/install.sh)

Installs godot-lib.aar, which is required to build the Android plugin.

(Will install default version in [build.env](./build.env) if no version is provided)

Example:

```sh
./scripts/android/install.sh 3.5
```

> [build.sh](./scripts/android/build.sh)

Installs and builds the Android plugin

This will also copy the built files to the `example/` projects (if you have installed Android custom build template)

(Will build default version in [build.env](./build.env) if no version is provided)

Example:

```sh
./scripts/android/build.sh 3.5
```

> [release.sh](./scripts/android/release.sh)

Builds and releases an Android plugin, the output will be in `.release/android/` folder.

(Will build and release all supported versions in [build.env](./build.env) if no version is provided)

Example:

```sh
# Release a specific version
./scripts/android/release.sh 3.5

# Release all versions
./scripts/android/release.sh
```

### iOS Scripts

> [install.sh](./scripts/ios/install.sh)

Installs Godot extracted headers, which are required to build the iOS plugin.

(Will install default version in [build.env](./build.env) if no version is provided)

Example:

```sh
./scripts/ios/install.sh 3.5
```

> [build.sh](./scripts/ios/build.sh)

Installs and builds the iOS plugin.

This will also copy the built files to the `example` projects (if you have exported the iOS project to `exported/ios`)

(Will build default version in [build.env](./build.env) if no version is provided)

Example:

```sh
./scripts/ios/build.sh 3.5
```

> [release.sh](./scripts/ios/release.sh)

Builds and releases an iOS plugin, the output will be in `.release/ios/` folder.

(Will build and release all supported versions in [build.env](./build.env) if no version is provided)

Example:

```sh
# Release a specific version
./scripts/ios/release.sh 3.5

# Release all version
./scripts/ios/release.sh
```