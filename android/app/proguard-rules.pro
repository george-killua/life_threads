# Flutter / LifeThreads release keep rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Drift / SQLite
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Image / camera / photo plugins used at runtime via reflection
-keep class com.baseflow.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class com.fluttercandies.photo_manager.** { *; }
-keep class dev.steenbakker.mobile_scanner.** { *; }

# In-app purchase
-keep class com.android.billingclient.** { *; }
-keep class io.flutter.plugins.inapppurchase.** { *; }

# Deferred components / Play Core optional stubs referenced by Flutter embedding
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
