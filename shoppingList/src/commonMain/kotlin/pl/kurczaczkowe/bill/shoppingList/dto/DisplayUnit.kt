package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class DisplayUnit(
    val baseUnit: String,
    val name: String,
    val shortName: String,
    val multiplier: Float,
)
