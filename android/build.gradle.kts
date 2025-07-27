plugins {
    // نسخه پلاگین اندروید را به 7.3.0 که سازگاری بیشتری با پکیج‌های قدیمی دارد، تغییر می‌دهیم
    id("com.android.application") version "7.3.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.10" apply false
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
