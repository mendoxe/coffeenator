# Cofeenator

A simple app to load random coffee image from [Random Coffee API](https://coffee.alexflipnote.dev/). With a possibility to save images locally to your device.

## Running the app

To run this app simply do:

```sh
flutter run
```

## Running the tests

To run the tests one would ideally run the following command:

```sh
very_good test --coverage --min-coverage 100 --test-randomize-ordering-seed random
```

In case you don't have very_good installed, you can run the tests by running:

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

To view the coverage report, run:

```sh
genhtml coverage/lcov.info -o coverage/

open coverage/index.html
```


## Features

This app is developed to let users browse random coffee images in a similiar style to applications like Tinder. While there is no destinction
between "liking" and "disliking" the images by swiping left or right, users can "like" (save) images to their favorites to view them at any time.

#### Discover

- Swipe down to refresh the image
- Click the heart button to like (save) the image to your device
- Click the broken heart button to remove an image from your favorites

#### Favorites

- View all your saved images
- Click the broken heart button to remove an image from your favorites


## Structure of the project

This project loosly follows layer-first architecture for clear separation of concerns.

- `lib/cubit` - Contains cubits along with their respective states
- `lib/repository` - Contains repositories 
- `lib/theme` - Contains theming of the app
- `lib/utils` - Contains utility functions along with extensions and constants
- `lib/ui` - Contains all the widgets (code related to visuals), pages and views

- `lib/test` - Contains tests for the app (tests are structured the same way the lib folders is for easier navigation)

## Architecture and code style

The app is developed using layer-first folder structure with aim to separate layers into their self-contained units. The layers are meant to be
used and developed in a "top-down" manner where layer "above" can call and listen to layer below it, but never the other way around to avoid 
unnecessary coupling between layers and thus make the app easier to maintain and test.

The structure is as follows (from left to right -> top to bottom):

**UI Layer (widgets, pages, views)** `lib/ui`  =>  **App logic - State managemenet (cubits, states)** `lib/cubit` => **Data layer (repositories)** `lib/repository` 


For all the layers as well as the project as a whole traditional software engineering principles apply (some important ones are mentioned below):

- Separation of concern - each layer should be dealing with its own responsibilities, same applies to components and widgets
- Keep it simple (KIS) - No abstractions for the sake of abstraction, no over-engineering simple problems without a clear goal. Widgets should be small and focused. Methods should be small and easy to reason about (larger methods should be broken into smaller ones).
- You ain't gonna need it (YAGNI) - If something MAY be needed in the future, implement it in the future. More code means more complexity, more maintenance and more potential for bugs.
- Don't repeat yourself (DRY) - If same code is written for the second time, it is a signal there is opportunity to refactor (interfaces, extensions, abstractions...). If same code is written for the third time, it should MOST-LIKELY be refactored. Keep in mind **KIS** and **YAGNI** principles.

                    
#### Testing

This project aims to have a 100% test coverage in allignment with very good ventures testing standards. This removes the burden of choice of which parts of the app to test and ensures that all layers are tested equally. 


## Future improvements

No software is perfect just like no person is perfect and that is totally fine. However, it is great if limitations are known and acknowledged. 

#### Error reporting

Error reporting would benefit from a service like Sentry to increase app stability observability. Currenly cubits are catching all errors and emitting
error states regardless of what type of error they caught. This is by design to avoid bothering users with (for non technical people) unreadble errors.
Nontheless, it would be very great to report the errors to crashlytics. Apart from that a couple of thoughts: there could either be a mechanism to 
auto-retry errors (likely with gradular backoff - trying it again with increasing delay) or letting user retry the event themselves. Both options have
their benefits and drawbacks - auto-retry may cause unnecessary computation (if I am offline there is no point to try to call the API again). User retry
may be clearer for some users, but confusing for others - user errors (aggresive retry tapping - draining resources).

#### Testing

While the app is currenly extremely simple, it may in the future benefit from integration tests when there are more complex scenarios to test. Both unit
tests and widget tests are implemented naively (testing the logic/component to avoid regressions and ensure app stability), but could potentially use
more robust strategy - testing all potential paths and all potential edge cases.

While modelling all paths even in a simple app can easily lead to combinatorial explosions, commonnly used practices to merge similiar logical events
would keep the test suite manageable. This approach is time consuming, but for critical applications is generally worth the time.