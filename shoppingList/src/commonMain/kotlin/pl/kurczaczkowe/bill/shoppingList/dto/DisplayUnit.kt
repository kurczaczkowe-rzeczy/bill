package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
data class DisplayUnit(
    @SerialName("base_unit")
    val baseUnit: String,
    val name: String,
    @SerialName("short_name")
    val shortName: String,
    val multiplier: Float,
)
