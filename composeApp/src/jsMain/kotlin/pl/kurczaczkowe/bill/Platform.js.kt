@file:JsExport
package pl.kurczaczkowe.bill

class JSPlatform: Platform {
    override val name: String = "Web with Kotlin/JS and Vue"
}

actual fun getPlatform(): Platform = JSPlatform()

fun get0(): Int {
    return 0
}