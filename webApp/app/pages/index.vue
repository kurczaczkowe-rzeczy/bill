<script lang="ts" setup>
import { type ShoppingList, ShoppingListClient } from "@bill/Bill-shoppingList";
import { Result } from "@bill/Bill-shoppingList/kotlin/Bill-core.mjs";

import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";

definePageMeta({
  layout: "list",
});

const shoppingListClient = new ShoppingListClient();

const { data, error, refresh } = await useAsyncData("shoppingLists", async () => {
  const response = await shoppingListClient.getShoppingListsAsync();

  if (response instanceof Result.Error) {
    throw new Error(response as any);
  }

  if (response instanceof Result.Success) {
    return ktToJs(response.result as KtList<ShoppingList>);
  }

  throw new Error("Unsupported response type: " + response.constructor.name + "");
});

const formNameError = ref("");

const nameRef = ref("");

async function addShoppingList(e: SubmitEvent) {
  if (nameRef.value.trim() === "") {
    formNameError.value = "Nazwa powinna być wypełniona";
    return;
  }
  shoppingListClient
    .createShoppingListAsync(nameRef.value)
    .then((data) => {
      if ("error" in data) {
        throw data.error;
      }
      (e.currentTarget as HTMLFormElement)?.reset();
      resetShoppingListForm();
      refresh();
    })
    .catch((err) => {
      console.error(err);
      formNameError.value = err.toString();
    });
}

function resetShoppingListForm() {
  nameRef.value = "";
  formNameError.value = "";
}
</script>

<template>
  <div class="card flex justify-center max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li>
        <form class="list-row" @submit.prevent="addShoppingList">
          <label class="list-col-grow">
            <input
                v-model="nameRef"
                :aria-invalid="!!formNameError"
                class="input input-ghost validator"
                placeholder="Nazwa listy"
                required
                type="text"
            />
            <span v-if="!!formNameError.trim()" class="validator-hint hidden">{{ formNameError }}</span>
          </label>
          <button class="btn btn-ghost btn-square">
            <Icon name="streamline-freehand:add-sign-bold" />
          </button>
        </form>
      </li>
      <li v-for="datum in data" v-if="data?.length" :key="datum.id" class="list-row">
        <NuxtLink :to="{ name: 'lists-id', params: { id: datum.id } }" class="list-col-grow">
          <span>{{ datum.name }}</span>
        </NuxtLink>
        <span>{{ datum.productAmount }} <Icon name="streamline-freehand:shopping-cart-trolley" /></span>
      </li>
      <li v-else class="list-row">Brak list</li>
    </ul>
    <div v-if="error">{{ error }}</div>
  </div>
</template>

<style>
</style>