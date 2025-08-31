<script lang="ts" setup>
import { definePageMeta } from "#imports";
import { useShoppingLists } from "~/composables/useShoppingListsClient";
import { handleResponseError } from "~/utils/handleResponseError";

definePageMeta({
  layout: "list",
});

const {
  shoppingLists,
  loading,
  error: shoppingListsError,
  addShoppingList,
  deleteShoppingList,
  updateShoppingList,
} = await useShoppingLists({ useAutoListenFor: ["shoppingListsChanges"] });

const formNameError = ref("");

const nameRef = ref("");

async function handleAddShoppingList(e: SubmitEvent) {
  addShoppingList({ name: nameRef.value || defaultName() })
    .then((response) => {
      handleResponseError(response);
      (e.currentTarget as HTMLFormElement)?.reset();
      resetShoppingListForm();
    })
    .catch((err) => {
      formNameError.value = err.toString();
    });
}

async function handleDelete(id: number) {
  deleteShoppingList({ id });
}

async function handleUpdate(id: number) {
  updateShoppingList({ id });
}

function resetShoppingListForm() {
  nameRef.value = "";
  formNameError.value = "";
}

function defaultName() {
  return new Intl.DateTimeFormat("pl-PL").format(new Date());
}
</script>

<template>
  <div class="card flex justify-center max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li class="p-4 grid grid-cols-[80px_1fr]">
        <Icon v-if="loading" class="animate-spin text-info" name="streamline-freehand:loading-star-1" />
        <span class="col-2 justify-self-end">List: {{ shoppingLists.length }}</span>
      </li>
      <li>
        <form class="list-row" @submit.prevent="handleAddShoppingList">
          <label class="list-col-grow">
            <input
                v-model="nameRef"
                :aria-invalid="!!formNameError"
                class="input input-ghost validator"
                :placeholder="defaultName()"
                type="text"
            />
            <span v-if="!!formNameError.trim()" class="validator-hint hidden">{{ formNameError }}</span>
          </label>
          <button class="btn btn-ghost btn-square">
            <Icon name="streamline-freehand:add-sign-bold" />
          </button>
        </form>
      </li>
      <li v-for="shoppingList in shoppingLists" v-if="shoppingLists?.length" :key="shoppingList.id" class="list-row">
        <NuxtLink :to="{ name: 'lists-id', params: { id: shoppingList.id } }" class="list-col-grow">
          <span>{{ shoppingList.name }}</span>
        </NuxtLink>
        <span>{{ shoppingList.productAmount }} <Icon name="streamline-freehand:shopping-cart-trolley" /></span>
        <button @click="handleDelete(shoppingList.id)"><Icon name="streamline-freehand:remove-delete-sign-bold" /></button>
      </li>
      <li v-else class="list-row">Brak list</li>
    </ul>
    <div v-if="shoppingListsError">{{ shoppingListsError }}</div>
  </div>
</template>

<style>
</style>