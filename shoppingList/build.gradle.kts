import love.forte.plugin.suspendtrans.configuration.SuspendTransformConfigurations.kotlinJsExportIgnoreClassInfo
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JsModuleKind
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.suspend.transform)
    alias(libs.plugins.kotlin.serialization)
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
            baseName = "shoppingList"
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
        androidMain {
            dependencies {
            }
        }

        commonMain {
            dependencies {
                implementation(projects.core)
                implementation(libs.kotlin.stdlib)
            }
        }

        iosMain {
            dependencies {
            }
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