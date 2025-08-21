package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.encodeToDynamic
import pl.kurczaczkowe.bill.shoppingList.utils.json
import kotlin.js.JsExport

@JsExport.Ignore
@OptIn(ExperimentalSerializationApi::class)
fun CategoryWithProducts.toJs(): dynamic = json.encodeToDynamic(this)
