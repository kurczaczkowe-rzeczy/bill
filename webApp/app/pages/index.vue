<script lang="ts" setup>
import BaseList from "~/components/BaseList.vue";
import { useShoppingLists } from "~/composables/useShoppingLists";
import { handleResponseError } from "~/utils/handleResponseError";

const {
  shoppingLists,
  loading,
  error: shoppingListsError,
  addShoppingList,
  deleteShoppingList,
  updateShoppingList,
} = useShoppingLists({ useAutoListenFor: ["shoppingListsChanges"] });

const formNameError = ref("");

const nameRef = ref("");

async function handleAddShoppingList(e: Event) {
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
    <BaseList
      class="card-body bg-base-100 rounded-box shadow-md w-full"
      :items="shoppingLists"
    >
      <template #static>
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
            <button class="btn btn-ghost btn-circle">
              <Icon name="streamline-freehand:add-sign-bold" />
            </button>
          </form>
        </li>
      </template>
      <template #item="{ item: shoppingList}">
        <NuxtLink :to="{ name: 'lists-id', params: { id: shoppingList.id } }" class="list-col-grow">
          <span>{{ shoppingList.name }}</span>
        </NuxtLink>
        <span>{{ shoppingList.productAmount }} <Icon name="streamline-freehand:shopping-cart-trolley" /></span>
        <button @click="handleDelete(shoppingList.id)">
          <Icon name="streamline-freehand:remove-delete-sign-bold" />
        </button>
      </template>
      <template #empty>Brak list</template>
    </BaseList>
    <div v-if="shoppingListsError">{{ shoppingListsError }}</div>
  </div>
</template>

<style>
</style>