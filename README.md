# E-Commerce Product Listing App

A simple Flutter e-commerce application built as part of a Flutter developer assignment.

The main goal of this project was to build a clean and scalable application with product listing, search, pagination, wishlist, offline support and dark mode.

---

## 📱 App Preview

### Login

![Login Screen](screenshots/login.png)

### Product Listing

![Product Listing](screenshots/products.png)

### Product Details

![Product Details](screenshots/product_details.png)

### Wishlist

![Wishlist](screenshots/wishlist.png)

### Dark Mode

![Dark Mode](screenshots/dark_mode.png)

---

## ✨ Features

- Dummy Login Authentication
- Product Listing
- Product Details
- Product Search
- Search Debounce
- Pagination
- Pull-to-Refresh
- Wishlist / Favorites
- Offline Product Caching
- Offline Wishlist Persistence
- Dark Mode
- Responsive Product Grid
- Loading States
- Empty States
- Error Handling
- Retry Mechanism
- API Timeout Handling
- No Internet Handling

---

## 🛠️ Tech Stack

- Flutter
- Dart
- BLoC
- Dio
- Hive
- Cached Network Image
- Clean / Feature-Based Architecture
- Repository Pattern
- DummyJSON API

---

## 🌐 API

This project uses the DummyJSON Products API:

https://dummyjson.com/products

The API is used for:

- Fetching products
- Searching products
- Pagination

---

## 🔄 State Management

BLoC is used for managing application state.

- `AuthBloc` → Login, logout and authentication state
- `ProductBloc` → Product loading, search, pagination and refresh
- `WishlistBloc` → Add, remove and load wishlist
- `ThemeCubit` → Light and dark mode

---

## 💾 Offline Storage

Hive is used for local data persistence.

The following data is stored locally:

- Product list/cache
- Wishlist/favorite products
- Login status
- Dark mode preference

When the internet is unavailable, cached product data can be used instead of showing a blank screen.

---

## ⚠️ Error Handling

The application handles common failure cases:

- No internet connection
- API timeout
- Server errors
- Empty search results
- Retry after failure

User-friendly messages are displayed instead of exposing technical errors directly.

---

## ⚡ Performance

The following approaches are used to keep the application smooth:

- Pagination for product loading
- Search debounce
- `GridView.builder` for efficient rendering
- Cached network images
- Separate loading and loading-more states
- `BlocSelector` to reduce unnecessary widget rebuilds
- Proper disposal of controllers and timers

---

## 🔐 Demo Login

Use the following credentials to access the application:

Email: `test@gmail.com`

Password: `123456`

---

## 🚀 How to Run

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android device/emulator

### Steps

```bash
git clone YOUR_REPOSITORY_URL
cd ecommerce_app_task
flutter pub get
flutter run

---


### 7. Build APK

```markdown
## 📦 APK

To generate the release APK:

```bash
flutter build apk --release

---

# 🏗️ Architecture

I used a feature-based architecture with separation between presentation, domain and data layers.

The main idea is to keep UI, business logic and API/local storage code separate so that the project can be easily maintained and extended.

```text
lib/
│
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── di/
│
├── features/
│   │
│   ├── auth/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │
│   ├── products/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── wishlist/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart

