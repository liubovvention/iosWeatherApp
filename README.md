# iosWeatherApp

Simple Weather App (Swift + SwiftUI)

## Weather App

This is a weather application designed for iPhones, built with **Swift** and **SwiftUI**. The app also utilizes **CoreData** for managing and caching data.

## Setup Instructions

1. Clone the repository:

   ```bash

   git clone https://github.com/liubovvention/iosWeatherApp.git

   ```

Open the project in Xcode.

Build and run the app on a simulator or a physical device.

Log in using the hardcoded credentials:

```markdown
Username: persik@gmail.com
Password: 123456789
```

After logging in, the weather information will be displayed for the predefined list of cities.

## Features

- **iPhone Support:** The app is designed specifically for iPhones.
- **Login:** The user needs to be logged in to use the app. For testing purposes, a hardcoded user is provided.
- **Weather Information:** Upon the first login, the user will see weather information for a predefined list of cities. Weather data is fetched from the [OpenWeather API](https://openweathermap.org/).
- **Caching:**
  - The weather information for the cities list is cached for 1 hour. This cached data is stored using **CoreData** to avoid fetching the same weather data repeatedly.
- **City List Management:**
  - If the user adds a new city or removes a city from the list, the weather will be refetched for the new list of cities, and the updated list will be saved in **CoreData**.

## How It Works

1. **User Login:**  
   The user logs in with the hardcoded credentials. After successful login, the weather data for a predefined list of cities is fetched from the OpenWeather API.
2. **Weather Data Caching:**  
   The fetched weather data is cached for 1 hour using **CoreData**. The app checks the cache before making any API calls to avoid unnecessary requests.
3. **Add/Remove Cities:**  
   The user can modify the list of cities. Adding or removing cities causes the app to refetch the weather data for the new list and store the updated list in **CoreData**.

## Technologies Used

- **Swift**
- **SwiftUI**
- **CoreData**
- **OpenWeather API**
