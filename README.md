# Weather App Flutter

A weather application built with Flutter that provides real-time weather information with dynamic backgrounds and hourly forecasts.

<img width="300" alt="Simulator Screenshot - iPhone 16 Plus - 2025-07-20 at 12 20 32" src="https://github.com/user-attachments/assets/07d085c1-551a-4dc4-8fd2-929e67f8967d" />
<img width="300" alt="Screenshot_1753007051" src="https://github.com/user-attachments/assets/4d7ee0f6-5828-46a0-b4d7-0d711de991ef" />
<img width="300" alt="Screenshot_1753008586" src="https://github.com/user-attachments/assets/4adcf61f-445e-4f8c-a22d-73faf3bad2b6" />
<img width="300" alt="Screenshot_1753009647" src="https://github.com/user-attachments/assets/c4f2590b-1d75-4eae-ad14-8a04e99f1dd1" />

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
- **Location-based real-time clock** that shows the current time in the selected location's timezone

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
