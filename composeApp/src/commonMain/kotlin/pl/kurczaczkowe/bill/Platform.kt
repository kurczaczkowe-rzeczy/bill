package pl.kurczaczkowe.bill

import kotlin.js.JsExport

@JsExport
interface Platform {
    val name: String
}

expect fun getPlatform(): Platform