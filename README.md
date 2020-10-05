# ![](https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/app-icon.png "App Icon") TvMaze App

This repository contains the code for an iOS app I built for a 5 days coding challenge. The idea was to build an iPhone app consuming an API that provides TV data about series, episodes and people.

http://www.tvmaze.com/api

## The requirements: 
* The user should be able to see a list of shows the API provides using a pagination mechanism
* The user should be able to search for a particular show
* The user should be able to check the show details
* On the show details, the user should be able to see a list of episodes split by seasons
* The user should be able to check the episode details
* The user should be able to search for a particular person
* The user should be able to check the person's details
* On the person's details, the user should be able to see a list of shows the person participated
* From the person's details list of shows, the user should be able to check the show details and episode details
* The user should be able to favorite a show (store the data in a Core Data database)
* The user should be able to secure the app from unauthorized people using Biometrics or a custom PIN

## The Maze TV API in details

I took a closer look on the API details to make sure the user will have a good **user experience** using the app, 
with good **usability**, **performance** and care with **privacy**.

The TV Maze API is free, without a authentication mechanism but it has a rate limit. 
This means that, if we **exceed a number of requests** the next ones should start to **fail**. 
This important, considering we can display a lot of information if the user **scrolls fast** and try to get more and more information.
Also, although the data is live in the cloud and can change at any moment, it **doesn't mean we need to download** the same data over and over again.
And finally and un-related with the Maze API. Some user information like the PIN needs to be stored with care, as it's sensible data.

So a good strategy for the development needs to consider:
* Downloads info **only when necessary**
* **Cache info** to avoid unnecessary network usage (images for instance)
* Have a well defined network layer, that can deal with the **rate limit errors** and **retry a few times**, when a request fails
* Store sensitive data using Keychain

## Architecture decisions

The architecture decisions I made, created a good separation of concerns, allowing the app to have a good testability and reusability. 
Also it provides a simple common API to deal with async operations for network or database.

For the views, I used a MVVM approach removing many responsibilities from the view controller and allowing me to better unit test my business logics.
To separate concerns, I splitted my app into different frameworks: **Core**, **Auth**, **Cloud**, **Database**, **Secure** and **Features**.

All my views and view models lives in the **Features** framework. If the this application grows, 
its advised to split this framework into other independent features, to improve the separation of concerns and build performance.

The following frameworks, I call Infrastructure layers: **Auth**, **Cloud**, **Database**, **Secure**. They deal with a very specific task being:
* **Auth** - Authentication using Touch ID or Face ID
* **Cloud** - Network requests
* **Database** - Core Data database access
* **Secure** - Keychain secure information storage

To make sure the code is isolated and the features, doesn't access them directly, the **Features** framework can't access the infrastructure layers directly. 
There's an additional framework called **Core** that helps with that. The **Core** framework exposes public protocols that can be used to apply a 
Dependency Injection mechanism in order for the view models to access the infrastructure mechanisms.

This is really interesting because later, it makes easier  to create mocks and write unit tests properly.

Another important architectural decision: I tried to avoid adding third party dependencies as much as possible. The only third party library I'm using is called PromiseKit.
With the promises pattern I could create a common API to deal with async data, and that allowed me to iterate faster while implementing the features.
I wish I could use apple's Combine framework here, as it's more standard, but this wasn't possible as I needed to support iOS 9 for this challenge.

This framework setup is best described with the image below:

![](https://github.com/fernandodelrio/TvMazeApp/blob/master/Documentation/images/modules-strategy.png "Modules strategy")

## Core Data strategy

Core Data is a super efficient local data mechanism on iOS, but is also a source of many issues when using it wrong.
In order to create a safer API in this project, I took the following decisions:

* Use a private queue for the NSManagedObjectContext. It needs to run with the **perform** method to ensure we are in the correct thread.
This way we never block the main thread providing a more fluid user interface. Because of this decision the calls to Core Data are always async
and we return a promise every time.
* Save the context only when necessary. This decision ensures we have the best possible performance as we are dealing with in memory data as 
much as possible
* Keep core data isolated in its framework. Parse the NSManagedObject to a simple data structure, before returning to the features. Using this approach,
we keep the features 100% isolated from the concepts of the Core Data and it creates a safer enviroment for when we deal with the database. Also makes easier to mock and create unit tests as I mentioned above.

## Network strategy

To make sure we don't face issues with the TV Maze API, I took the following decisions:

* When performing a request always check for the rate limit error. Whenever an error returns, retry that request 3 times, adding a small delay between then.
* Returns a promise for each network request. This allows me to deal with the network calls with a common API as we do for the database. 
With that, its easier to compose the data to display in the user interface.
* Whenever we download an image, we save it in a NSCache instance. So the next time that image is requested, we can just return the cached image and avoid network usage.

## Listing informations to the user

Whenever I needed to display a list of informations to the user (shows, people, episodes, for instance), 
I make sure to don't wait until all information are available in memory. 

This is important to create a more **fluid user interface**. So whenever the Maze API returns the data I immediately
display to the user the text and start to load the images separatedly. Because of this decision the data always appears as fast as possible to the user.

## Apple guidelines and adapting to different devices

I tried to not innovate too much in the user interface, to be able to iterate faster and avoid UI issues. I wish I could have used some trending features like the dark mode here, but I didn't do it because of the iOS 9 support. I stick to standard patterns for iOS interface:
* A tab bar controller leading to the main app features
* A navigation controllers to navigate to different flows

By using a simpler approach, the app worked fine on different device sizes. I had an exception on the show details screen, 
that had too much information and because of that I created a variation for devices with smaller screens like iPhone SE and iPhone 8. On the episode details,
some summaries were really large, and I make sure to put a scroll view, to avoid any issues to display larger contents, so there was no need to create a variation for different device sizes.

## Project setup

To setup the project I used 2 tools: Xcodegen (https://github.com/yonaskolb/XcodeGen) and CocoaPods (https://cocoapods.org). The first one is used to generate the structure of an xcode project following a spec file (really useful to avoid merge conflits on the project file). The second one, is part of the requirements of the challenge and I use to keep track of the third party libraries.

Once the project is cloned you don't need to follow any special step to setup the project, it should be ready to use. Just open the **TvMaze.xcworkspace** file. 
But if you want to try the project generation just call the Makefile:

```shell
$ make project
```

## Swift Lint

I set up Swift Lint in the project to validate I was following a set of good code practices. The setup of the swift lint rules are available in a **.swiftlint.yml** file.

## Unit and UI Tests

With all the strategy I mentioned above, unit testing was an easy task. The **Core** framework exposes an **Dependency** class that can be used to resolve any protocol exposed there: **ShowProvider**, 
**EpisodeProvider**, **PersonProvider**, **FavoriteProvider**, **SecretProvider**, **ImageCacheProvider**, **AuthProvider**, **EndpointProvider**, **RequestProvider**, **SettingsProvider**.

In the app delegate another class called **Injector** register all these **abstract** types to its **concrete** implementations in the infrastructure layer.
But when we come to do unit tests, another class called **TestInjector** register a different **concrete** implementation for these types. 
These implementations are the mock classes that helps us to isolate and unit test each class individually.

Because of the short time, I didn't wrote a full coverage of all classes in the project, but I could cover with unit test the majority of the flows of 
my main view models, demonstrating how to use this mocking mechanism.

Regarding the UI Tests, I also didn't wrote test for all possible flows, but create an interesting test that:
* Searches for a person
* Navigate to the person's details
* Favorites a particular show, the person participated
* Navigate to that show
* Unfavorite the show there
* Navigate to an episode of the show
* Assert the summary of that episode

Even not reaching the all possible tests I could reach a good coverage of the most important frameworks:

![](https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/cove-coverage.png "Code coverage")

## Missing requirements

The original requirement mentioned the following:

* Xcode 8.2+
* Swift 3
* iOS 9.0+

They seem a really outdated setup, unfortunately my O.S. is on macOS Catalina and it doesn't support Xcode 8.2. 
I was also unable to use Swift 3, because it's too old for my machine. Because of that, I skipped both requirements.

I am using Xcode 11.3.1 with Swift 5. Still I was able to support iOS 9 and this choice won't impact anything to the end user.

## Finally, the working app

In this last section I will put a link for a video demonstration of the app + a set of images of the app's user interface, I hope you enjoy. Feel free to get the project and run to check it yourself.

### Demonstration video

https://drive.google.com/file/d/1fdEFUziJvECuW6pAdpvnDn14NpIBxoDG/view?usp=sharing

### Shows list

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/show-list.png" width="300" />

### Show details

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/show-details.png" width="300" />

### Episode details

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/episode-details.png" width="300" />

### People list

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/people-list.png" width="300" />

### Person details

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/person-details.png" width="300" />

### Favorites

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/favorites.png" width="300" />

### Enable Touch ID (tested on iPhone 8)

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/enable-touch-id.png" width="300" />

### Enable Face ID (tested on iPhone Xs)

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/enable-face-id.png" width="300" />

### Enable PIN (tested on iPhone SE)

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/enable-pin.png" width="300" />

### Authenticate with Touch ID

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/auth-touch-id.png" width="300" />

### Authenticate with Face ID (the UI won't appear properly in the simulator)

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/auth-face-id.png" width="300" />

### Authenticate with PIN

<img src="https://raw.githubusercontent.com/fernandodelrio/TvMazeApp/master/Documentation/images/enter-pin.png" width="300" />

### Invalid PIN entered

<img src="https://github.com/fernandodelrio/TvMazeApp/blob/master/Documentation/images/invalid-pin.png" width="300" />
