<script lang="ts" setup>
definePageMeta({
  alias: "/lists",
  nav: {
    name: "shopping-lists",
    icon: "streamline-freehand:task-list-pen",
    label: "Listy Zakupów",
  },
});

import BaseButton from "@ui/components/BaseButton.vue";

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
  refresh
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

async function handleDelete(id: string) {
  deleteShoppingList({ id });
}

async function handleUpdate(id: string) {
  updateShoppingList({ id });
}

function resetShoppingListForm() {
  nameRef.value = "";
  formNameError.value = "";
}

function defaultName() {
  return new Intl.DateTimeFormat("pl-PL").format(new Date());
}

function refreshList() {
  refresh();
}

function handleVisibilityChange() {
  if (document.visibilityState === "visible") {
    refresh();
  }
}

onMounted(() => {
  document.addEventListener("visibilitychange", handleVisibilityChange);
})

onUnmounted(() => {
  document.removeEventListener("visibilitychange", handleVisibilityChange);
})
</script>

<template>
  <div class="card flex flex-col max-w-xl m-auto max-h-screen">
    <div class="card-body bg-base-100 rounded-box shadow-md w-ful gap-4 overflow-y-auto">
      <div class="flex gap-4 items-center">
        <BaseButton circle to="auth/login">
          <Icon name="streamline-freehand:login-rectangle" />
        </BaseButton>
        <BaseButton circle @click="refreshList">
          <Icon name="streamline-freehand:synchronize-arrows" />
        </BaseButton>
        <p class="basis-full flex items-center justify-end gap-2">
          <Icon v-if="loading" class="animate-spin text-info" name="streamline-freehand:loading-star-1" />
          <span>List: {{ shoppingLists.length }}</span>
        </p>
      </div>
      <form class="flex items-center gap-4 w-full" @submit.prevent="handleAddShoppingList">
        <label class="w-full" for="shopping-list-name">
          <BaseTextInput
            id="shopping-list-name"
            name="shopping-list-name"
            class="validator"
            v-model="nameRef"
            :aria-invalid="!!formNameError"
            :placeholder="defaultName()"
          />
          <span v-if="!!formNameError.trim()" class="validator-hint hidden">{{ formNameError }}</span>
        </label>
        <BaseButton circle size="sm" type="submit">
          <Icon name="streamline-freehand:add-sign-bold" />
        </BaseButton>
      </form>
      <div class="divider m-0"></div>
      <BaseList
        :items="shoppingLists"
        class="overflow-y-auto -mx-(--card-p,1.5rem) px-(--card-p,1.5rem)"
        :item-props="() => ({ class: 'items-center -mx-4' })"
      >
        <template #item="{ item: shoppingList}">
          <NuxtLink :to="{ name: 'lists-id', params: { id: shoppingList.id } }" class="list-col-grow">
            <span>{{ shoppingList.name }}</span>
          </NuxtLink>
          <span>{{ shoppingList.productAmount }} <Icon name="streamline-freehand:shopping-cart-trolley" /></span>
          <BaseButton circle size="sm" @click="handleDelete(shoppingList.id)">
            <Icon name="streamline-freehand:remove-delete-sign-bold" />
          </BaseButton>
        </template>
        <template #empty>Brak list</template>
      </BaseList>
      <div v-if="shoppingListsError">{{ shoppingListsError }}</div>
    </div>
  </div>
</template>

<style>
</style>