package pl.kurczaczkowe.bill.core.auth

import kotlin.js.JsExport

@JsExport
data class AuthUser(
    val id: String?,
    val email: String?
)