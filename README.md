# Fairway App

## Main Features

- Responsive product listing grid
- product search with debounce
- Category filtering
- Price sorting
- Pagination / infinite scrolling
- Pull-to-refresh
- Loading, error, empty, and offline states
- Product detail screen with image carousel
- Similar products by category
- Delete products with confirmation
- Create new products
- Deep-linkable product detail routes
- Offline caching of the latest successful products
- Persistent favourites using local storage
- Light/dark theme support
- Responsive layouts for phones and tablets

---

## Setup Instructions

### Flutter Version

- Flutter SDK: 3.38.5 (stable channel)

Navigate to the project directory.

### Install dependencies

```bash
flutter pub get
```

### Run the project

```bash
flutter run
```

### Build an APK

```bash
flutter build apk --release
```

The generated APK will be available at:

`build/app/outputs/flutter-apk/app-release.apk`

---

## Architecture

The application follows a lightweight layered architecture inspired by Clean Architecture, with clear separation between presentation, state management, and data access.

Full Clean Architecture was intentionally not implemented because the additional abstraction would introduce unnecessary complexity for the scope of this application.

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── errors/
│   ├── routing/
│   ├── services/
│   └── ...
├── features/
│   ├── products/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repository/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   │       └── cubit/
│   └── create_product/
│   │   ├── ...
│   └── .../
└── main.dart
```

---

## State Management Approach

The application uses **Bloc Cubit** for managing application state.

Cubits were chosen because they provide a convenient way to manage states throughout the application. It allows to manage UI state while seperating business logic from the UI. Cubits also abstracts the additional event-handling complexity of pure BLoC, which is unnecessary for the scope of this application.

The application uses Cubits for product listing, product details create-listing flows and theme handling.

**setState** is used for simple local UI state

---

## API Integration Approach

The app uses the public **DummyJSON API** (`https://dummyjson.com/products`) as the backend.
The API is accessed through a single HTTP client (http)

---

## Local Storage

`SharedPreferences` is used to store and manage:

- Cached products
- Selected theme preference
- Favourite product IDs

---

## Navigation

GoRouter is used for declarative navigation.

Product details are accessible through deep linking routes such as:

/product/:id

---

## Trade-offs & Limitations

- DummyJSON simulates create and delete operations rather than providing persistent backend storage. Therefore, created and deleted products are reflected in the application's local state only.
- DummyJSON does not support combining category filtering and search in a single request. Therefore, the application handles this limitation by navigating to the All category when a search is performed while a category is selected. Conversely, switching categories while a search query is active clears the search query and applies the selected category.
- DummyJSON does not support retrieving products using a list of product IDs. Therefore, while favourite products are persisted locally, a dedicated Favourites filter is not applied to the product listing.
- The product data provided by DummyJSON is not golf-specific. Therefore the available data is used assuming they are golf-related products

---

## Improvements

- Include widget tests and unit tests

## Tested on

- iOS Simulator
- Android device

## Screenshots

- [Phone Screenshots (iOS simulator)](https://drive.google.com/drive/folders/1BGZwqEaJvoCrLR29QsyJhbrqbHzAxtna?usp=sharing)

## Demo Video

- [Phone Demo Video (iOS simulator)](https://drive.google.com/drive/folders/1NmSyRt4V-RiwguANG9VxTEPEsM6V5bJR?usp=sharing)

## APK

- [Download APK](https://drive.google.com/drive/folders/1zHSJi-SN9QcHLFOQEXwt07bfYklj54-O?usp=sharing)
