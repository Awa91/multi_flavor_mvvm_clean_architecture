plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.multi_flavor_mvvm_clean_architecture"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion


    // 1. Define Flavor Dimensions
    // Dimensions are prioritized from left to right for resource merging
    flavorDimensions.add("brand")
    flavorDimensions.add("environment")

    productFlavors {
        // --- BRAND DIMENSION ---
        // Assets in src/alpha/res will override src/main/res
        create("alpha") {
            dimension = "brand"
            applicationIdSuffix = ".alpha"
            manifestPlaceholders["appName"] = "Alpha Brand"
        }
        create("beta") {
            dimension = "brand"
            applicationIdSuffix = ".beta"
            manifestPlaceholders["appName"] = "Beta Brand"
        }

        // --- ENVIRONMENT DIMENSION ---
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
        }
        create("qa") {
            dimension = "environment"
            applicationIdSuffix = ".qa"
        }
        create("prod") {
            dimension = "environment"
        }
    }















    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.multi_flavor_mvvm_clean_architecture"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
