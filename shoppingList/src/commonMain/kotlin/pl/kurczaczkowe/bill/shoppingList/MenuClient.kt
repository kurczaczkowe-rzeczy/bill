package pl.kurczaczkowe.bill.shoppingList

import love.forte.plugin.suspendtrans.annotation.JsPromise
import pl.kurczaczkowe.bill.core.networking.RemoteClient
import pl.kurczaczkowe.bill.core.util.NetworkError
import pl.kurczaczkowe.bill.core.util.Result
import pl.kurczaczkowe.bill.shoppingList.dto.CreateMealWithIngredients
import pl.kurczaczkowe.bill.shoppingList.dto.CreateMealWithIngredientsParameters
import pl.kurczaczkowe.bill.shoppingList.dto.CreateUserMealIngredientParameter
import pl.kurczaczkowe.bill.shoppingList.dto.GetUserMealIngredientsParameters
import pl.kurczaczkowe.bill.shoppingList.dto.GetUserMealParameters
import pl.kurczaczkowe.bill.shoppingList.dto.Ingredient
import pl.kurczaczkowe.bill.shoppingList.dto.UserMeal
import pl.kurczaczkowe.bill.shoppingList.dto.UserMealWithIngredients
import kotlin.js.JsExport

@JsExport
class MenuClient(private val client: RemoteClient) {

    @JsPromise
    @JsExport.Ignore
    suspend fun createMealWithIngredients(
        param: CreateMealWithIngredients
    ): Result<String, NetworkError> {
        return try {
            client.post<CreateMealWithIngredientsParameters, String>(
                rpcFunction = "create_meal_with_ingredients",
                parameters = CreateMealWithIngredientsParameters(
                    name = param.name,
                    type = param.type,
                    recipeDesc = param.recipeDesc,
                    recipeLink = param.recipeLink,
                    servings = param.servings,
                    servingsMultiplier = param.servingsMultiplier,
                    ingredients = param.ingredients.map { CreateUserMealIngredientParameter(productId = it.productId, quantity = it.quantity) },
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun getMeal(
        userMealId: String,
    ): Result<UserMealWithIngredients, NetworkError> {
        return try {
            client.post<GetUserMealParameters, UserMealWithIngredients>(
                rpcFunction = "get_user_meal",
                parameters = GetUserMealParameters(
                    userMealId = userMealId
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun getMeals(): Result<List<UserMeal>, NetworkError> {
        return try {
            client.post<List<UserMeal>>(
                rpcFunction = "get_user_meals"
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

    @JsPromise
    @JsExport.Ignore
    suspend fun getMealIngredients(
        userMealId: String,
    ): Result<List<Ingredient>, NetworkError> {
        return try {
            client.post<GetUserMealIngredientsParameters, List<Ingredient>>(
                rpcFunction = "get_user_meal_ingredients",
                parameters = GetUserMealIngredientsParameters(
                    userMealId = userMealId
                )
            )
        } catch (e: Exception) {
            println(e)
            Result.Error(NetworkError.UNKNOWN)
        }
    }

}


