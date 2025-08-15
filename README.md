# Bill

## Overview

Bill is a full-stack application leveraging the power of Kotlin Multiplatform (KMP) for shared business logic, Compose Multiplatform for creating a native multiplatform user interface (Android, iOS, Desktop), and Nuxt.js for a modern web frontend.

This project aims to manage your bill and track your expenses. Also, provide convenient ways to make a shopping list.

## Features

*   **Shared Business Logic:** Kotlin Multiplatform allows us to write common code (e.g., data models, business rules, networking) once in Kotlin and share it across all platforms.
*   **Native User Interfaces with Compose Multiplatform:**
  *   **Android:** Modern, declarative UI built with Jetpack Compose.
  *   **iOS:** Native UI leveraging Compose for iOS.
*   **Web Frontend with Nuxt.js:** A Vue.js framework for building performant and SEO-friendly web applications.

## Technology Stack

*   **Shared (KMP):**
    *   [Kotlin](https://kotlinlang.org/)
    *   [Ktor](https://ktor.io/)
    *   [Kotlinx Serialization](https://github.com/Kotlin/kotlinx.serialization)
    *   [Coroutines](https://kotlinlang.org/docs/coroutines-overview.html) 
*   **Client (Compose Multiplatform):**
    *   [Compose Multiplatform](https://www.jetbrains.com/lp/compose-multiplatform/)
    *   [Jetpack Compose](https://developer.android.com/jetpack/compose)
*   **Web (Nuxt.js):**
    *   [Nuxt.js](https://nuxtjs.org/)
    *   [Vue.js](https://vuejs.org/)
*   **Build Tool:**
    *   [Gradle](https://gradle.org/) (with Kotlin DSL)

## Project Structure

A brief overview of the key modules/directories:

*   `composeApp/`: Contains the UI implementation using Compose Multiplatform.
*   `core/`: Kotlin Multiplatform module containing common business logic, data models, etc.
*   `shoppingList/`
*   `shoppingList/`
*   `iosApp/`: iOS application project (Xcode).
*   `webApp/`: Contains the Nuxt.js web application.

Every module has a `build.gradle.kts` file that configures the module and structure like:
*   `commonMain/`: Code shared across all platforms.
*   `androidMain/`: Kotlin code specific to Android.
*   `iosMain/`: Kotlin code specific to iOS.
*   `jsMain/`: Kotlin code that can be compiled to JavaScript.


## Getting Started

### Prerequisites

*   [Android Studio](https://developer.android.com/studio) (latest stable version recommended)
*   [Xcode](https://developer.apple.com/xcode/) (for iOS development)
*   [JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) (Version compatible with your Android Gradle Plugin and Kotlin version)
*   [Node.js and npm/yarn](https://nodejs.org/) (for Nuxt.js development)

### Setup & Running

**Runs configurations:**

*   Open the project in Android Studio.
*   Gradle will automatically sync and download dependencies.
*   `composeApp` - run application on Android emulator or connected device.
*   `run full app` - run application on Android emulator or connected device and nuxt app.
*   `run web` - run nuxt app.