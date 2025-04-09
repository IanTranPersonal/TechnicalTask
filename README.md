# Race Tracking App

## Overview

This repository contains a Swift app developed for a technical task, which fetches and displays race data from the Neds API, with filtering capabilities based on start times and race categories.

## Additional Notes + Considerations
- Whilst the endpoint given is limited to 10 results, the app will ingest 50 when changing the count. This is because;
- When a specific filter to the type is applied, there may not be enough of a specific type to make up the target(5) number of races - this could be rectified with the endpoint allowing additional filters
such as the (i'm assuming) live endpoint documentation [here](https://nedscode.github.io/affiliate-feeds/#racing-meetings) which allows getting more by type.
Whilst this would require an update to how the network call works, it would be more beneficial to ensure we are retreiving enough of the given types at any one time to "top up" the list.
However for the moment, we're ingesting 50 results instead of the 10 from the endpoint to have a better chance of getting more of the required types of races.
- Obvious improvements also include getting the correct images for the types of races; however the stand in for now is system images.


## Features

- Fetches race data from the Neds API - https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10
- Displays upcoming races in an intuitive and easy to use interface (including races that have started for up to 1 minute)
- Categorizes and filters races by race type (greyhound, harness, horse)
- Handles loading states and errors gracefully via SwiftUI and Combine

## Technology Stack

- **UI Framework**: SwiftUI
- **Reactive Programming**: Combine
- **Architecture**: MVVM (Model-View-ViewModel)
- **Networking**: URLSession with Combine publishers
- **Testing**: XCTest and Swift Testing
- **Minimum iOS Version**: iOS 17+
- **Swift Version**: Swift 5.5+

## Project Structure

```
RaceApp/
├── App/                        # App entry point and main configuration
├── Models/                     # Data models for races and related entities
├── Views/                      # SwiftUI views
│   ├── RaceList/               # Race listing views
│   ├── RaceDetail/             # Race detail views
│   └── Components/             # Reusable UI components
├── ViewModels/                 # ViewModels for respective views
├── Services/                   # API and data services
│   ├── NetworkService/         # Networking layer
│   └── TimerService/           # Improved timer handling

Tests/
├── UnitTests/                  # Unit tests for individual components
```

## Getting Started

### Prerequisites

- Xcode 16.0 or later
- iOS 17.0+ deployment target
- Swift 5.5+

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/IanTranPersonal/TechnicalTask.git
   cd TechnicalTask
   ```

2. Open the project in Xcode:
   ```bash
   open RaceApp.xcodeproj
   ```

3. Build and run the application using the Xcode simulator or a connected device.

### API Configuration

The app connects to the Neds API for fetching race data. No API key is required for the demonstration version of the app.

## Running Tests

To run the tests:

1. Open the project in Xcode
2. Press `⌘+U` or navigate to Product > Test in the menu

The test suite includes:
- Unit tests for ViewModels

## Approach and Design Decisions

### Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:
- **Models**: Represent the race data structure
- **Views**: SwiftUI views for displaying the UI
- **ViewModels**: Handle business logic and data transformation for views

### Data Flow

1. The app fetches race data from the API using the `NetworkService`
2. Data is transformed and processed in the ViewModels
3. SwiftUI views observe the ViewModels for changes
4. Users can filter races based on category


## License

This project is provided for evaluation purposes as part of a technical assessment.
