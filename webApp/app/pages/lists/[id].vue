<script lang="ts" setup>
import { ShoppingListClient, type ShoppingListDetails } from "@bill/Bill-shoppingList";

import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";

const route = useRoute();

const shoppingListClient = new ShoppingListClient();

const { data, error } = await useAsyncData("shoppingListDetails", async () => {
  const response = await shoppingListClient.getShoppingListAsync(route.params.id);

  if ("error" in response) {
    throw new Error(response as any);
  }

  if (!("result" in response)) {
    throw new Error("Unsupported response type: " + response.constructor.name + "");
  }

  return ktToJs(response.result as KtList<ShoppingListDetails>);
});
function toggleInCart(inCart: boolean) {
  console.log("togleInCart->", inCart);
}
</script>

<template>
  <div class="card flex justify-center flex-col max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li class="px-2">
        <NuxtLink to="/">
          <Icon name="streamline-freehand:keyboard-arrow-return"/>
        </NuxtLink>
      </li>
      <li
          v-for="datum in data"
          v-if="data?.length"
          :key="datum.id"
          :class="{ 'line-through': datum.inCart}"
          class="list-row"
          @click="toggleInCart( datum.inCart )"
      >
        <span class="list-col-grow">{{ datum.name }} : {{ datum.unit }}</span>
        <!--      <span>category: {{ datum.category }}</span>-->
        <span>{{ datum.quantity }} {{ datum.unit }}</span>
      </li>
      <li v-else class="list-row">Brak produktów na liście</li>
    </ul>
    <div v-if="error">{{ error }}</div>
  </div>
</template>

<style scoped>

</style>