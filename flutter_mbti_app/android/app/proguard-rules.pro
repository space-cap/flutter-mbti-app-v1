# Flutter 앱용 ProGuard 규칙

# Flutter 관련 클래스 유지
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Dart 관련 클래스 유지
-keep class dartx.** { *; }

# JSON Serialization
-keepattributes *Annotation*
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# SharedPreferences 관련
-keep class androidx.preference.** { *; }

# 기본 Android 최적화 설정
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# 최적화 설정
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification