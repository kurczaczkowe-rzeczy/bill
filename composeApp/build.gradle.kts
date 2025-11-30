import love.forte.plugin.suspendtrans.configuration.SuspendTransformConfigurations.kotlinJsExportIgnoreClassInfo
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JsModuleKind
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidApplication)
    alias(libs.plugins.composeMultiplatform)
    alias(libs.plugins.composeCompiler)
    alias(libs.plugins.kotlin.serialization)
    alias(libs.plugins.suspend.transform)
}

kotlin {
    compilerOptions {
        freeCompilerArgs.add("-Xes-long-as-bigint")
    }

    androidTarget {
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
    
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "ComposeApp"
            isStatic = true
        }
    }

    js(IR) {
        useEsModules()
        browser {
            compilerOptions {
                target = "es2015"
                moduleKind.set(JsModuleKind.MODULE_ES)
            }
        }
        binaries.library()
        generateTypeScriptDefinitions()
        compilations.all {
            packageJson {
                customField("types", "kotlin/$name.d.mts")
                customField("type", "module")
            }
        }
    }

    sourceSets {
        
        androidMain.dependencies {
            api(compose.preview)
            api(libs.androidx.activity.compose)
        }
        commonMain.dependencies {
            api(compose.runtime)
            api(compose.foundation)
            api(compose.material)
            api(compose.ui)
            api(compose.components.resources)
            api(compose.components.uiToolingPreview)
            implementation(projects.product)
            implementation(projects.shoppingList)
            implementation(projects.core)
            implementation(libs.androidx.lifecycle.viewmodel)
            implementation(libs.androidx.lifecycle.runtime.compose)
        }
        jsMain.dependencies {
        }
        nativeMain.dependencies {
        }
        all {
            languageSettings.apply {
                optIn("kotlin.js.ExperimentalJsExport")
                optIn("kotlin.js.ExperimentalJsFileName")
            }
        }
    }
}

android {
    namespace = "pl.kurczaczkowe.bill"
    compileSdk = 35

    defaultConfig {
        applicationId = "pl.kurczaczkowe.bill"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildToolsVersion = "35.0.0"
    lint {
        baseline = file("lint-baseline.xml")
    }
}

dependencies {
    debugImplementation(compose.uiTooling)
}

suspendTransformPlugin {
    transformers {
        addJsPromise {
            addCopyAnnotationExclude {
                from(kotlinJsExportIgnoreClassInfo)
            }
        }
    }
}