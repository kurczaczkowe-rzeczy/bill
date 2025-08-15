package pl.kurczaczkowe.bill.shoppingList.utils

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json

@OptIn(ExperimentalSerializationApi::class)
val json = Json {
    encodeDefaults = false
    explicitNulls = false
    classDiscriminator = "type"
}
