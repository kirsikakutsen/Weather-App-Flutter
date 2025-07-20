# Weather App Flutter

A weather application built with Flutter that provides real-time weather information with dynamic backgrounds and hourly forecasts.

## Features

### Current Weather
- **Real-time temperature display**
- **Current weather conditions**
- **Dynamic weather icons** that change based on current conditions
- **Location-based weather** using GPS coordinates

### Dynamic UI
- **Time-based background gradients** that change throughout the day:
  - **Morning** (5 AM - 12 PM): Warm orange to yellow gradient
  - **Afternoon** (12 PM - 4 PM): Blue to cream gradient
  - **Evening** (4 PM - 11 PM): Blue to pink gradient
  - **Night** (11 PM - 5 AM): Dark blue to purple gradient
- **Immersive full-screen experience** with hidden system UI
- **Responsive design** that adapts to different screen sizes

### Location & Time
- **Automatic location detection** using device GPS
- **City and country display** with reverse geocoding
- **Real-time clock** 
- **Date display** 

### Hourly Forecast
- **24-hour weather forecast** with hourly breakdown
- **Horizontal scrollable list** of hourly weather data
- **Temperature predictions** for each hour
- **Weather condition icons** for each time slot
- **Time labels** in 24-hour format

## Tech Stack

### Core Framework
- **Flutter** 
- **Dart** 

### Dependencies
- **flutter_svg** (^2.0.7) - SVG image rendering
- **http** (^0.13.3) - HTTP requests for weather API
- **intl** (^0.20.2) - Internationalization and date formatting
- **geolocator** (^9.0.2) - GPS location services
- **geocoding** (^2.0.5) - Reverse geocoding for city names
- **flutter_dotenv** (^5.1.0) - Environment variable management

### Weather API
- **Visual Crossing Weather API** - Provides weather data including:
  - Current conditions
  - Hourly forecasts
  - Temperature data
  - Weather conditions and icons
  - Timezone information

### Architecture
- **Clean Architecture** with separation of concerns:
  - **Presentation Layer** - UI components and screens
  - **Domain Layer** - Business logic and repositories
  - **Data Layer** - Models and services
- **Repository Pattern** for data access
- **Service Layer** for external API calls and location services

### Project Structure
```
lib/
├── core/
│   └── constants/
│       └── colors.dart          # App color definitions
├── domain/
│   └── repository/
│       └── weather_repository.dart  # Weather data fetching
├── models/
│   └── weather_model.dart       # Data models
├── presentation/
│   └── forecast_screen.dart     # Main weather screen
├── services/
│   └── location_service.dart    # GPS and geocoding
├── utils/
│   └── weather_icon_mapper.dart # Weather icon mapping
└── main.dart                    # App entry point
```
