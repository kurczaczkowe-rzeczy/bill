package pl.kurczaczkowe.bill.shoppingList.dto

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.encodeToDynamic
import pl.kurczaczkowe.bill.shoppingList.utils.json

@JsExport.Ignore
@OptIn(ExperimentalSerializationApi::class)
fun ShoppingListDetails.toJs(): dynamic = json.encodeToDynamic(this)