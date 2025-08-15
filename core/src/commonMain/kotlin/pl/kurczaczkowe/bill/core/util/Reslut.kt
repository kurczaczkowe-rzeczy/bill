package pl.kurczaczkowe.bill.core.util

import kotlinx.serialization.Serializable
import kotlin.js.JsExport
import kotlin.js.JsName

@JsExport
@Serializable
sealed class Result<out R, out E : BaseError> {
    @Serializable
    data class Success<out R>(@JsName("result") val result: R) : Result<R, Nothing>()

    @Serializable
    data class Error<out E : BaseError>(@JsName("error") val error: E) :
        Result<Nothing, E>()
}

@JsExport
inline fun <T, E : BaseError, R> Result<T, E>.map(map: (T) -> R): Result<R, E> {
    return when (this) {
        is Result.Error -> Result.Error(error)
        is Result.Success -> Result.Success(map(result))
    }
}

@JsExport
fun <T, E : BaseError> Result<T, E>.asEmptyDataResult(): EmptyResult<E> {
    return map { }
}

@JsExport
inline fun <T, E : BaseError> Result<T, E>.onSuccess(action: (T) -> Unit): Result<T, E> {
    return when (this) {
        is Result.Error -> this
        is Result.Success -> {
            action(result)
            this
        }
    }
}

@JsExport
inline fun <T, E : BaseError> Result<T, E>.onError(action: (E) -> Unit): Result<T, E> {
    return when (this) {
        is Result.Error -> {
            action(error)
            this
        }

        is Result.Success -> this
    }
}

typealias EmptyResult<E> = Result<Unit, E>
