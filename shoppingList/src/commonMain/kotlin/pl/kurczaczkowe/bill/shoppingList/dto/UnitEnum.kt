package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.Serializable
import kotlin.js.JsExport

@JsExport
@Serializable
enum class UnitEnum(s: String) {
    METER("METER"),
    CENTIMETER("CENTIMETER"),
    MILLILITER("MILLILITER"),
    LITER("LITER"),
    KILOGRAM("KILOGRAM"),
    GRAM("GRAM"),
    QUANTITY("QUANTITY"),
    PACK("PACK")
}