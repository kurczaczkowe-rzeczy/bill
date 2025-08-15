<script lang="ts" setup>
import { type ShoppingList, ShoppingListClient } from "@bill/Bill-shoppingList";
import { Result } from "@bill/Bill-shoppingList/kotlin/Bill-core.mjs";

import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";

definePageMeta({
  layout: "list",
});

const shoppingListClient = new ShoppingListClient();

const { data, error } = await useAsyncData("shoppingLists", async () => {
  const response = await shoppingListClient.getShoppingListsAsync();

  if (response instanceof Result.Error) {
    throw new Error(response as any);
  }

  if (response instanceof Result.Success) {
    return ktToJs(response.result as KtList<ShoppingList>);
  }

  throw new Error("Unsupported response type: " + response.constructor.name + "");
});
</script>

<template>
  <div class="card flex justify-center max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li v-for="datum in data" v-if="data?.length" :key="datum.id" class="list-row" >
        <span>{{ datum.date }}</span>
        <NuxtLink :to="{ name: 'lists-id', params: { id: datum.id } }">
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