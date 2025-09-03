<script lang="ts" setup>
import { type Category, type Product, UnitEnum } from "@bill/Bill-shoppingList";

import {
  type AddToShoppingListParameters,
  useShoppingList,
} from "~/composables/useShoppingListClient";
import { categoryClient, productClient } from "~/constants";
import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";

const route = useRoute();

const units = UnitEnum.values();

const {
  categoriesWithProducts,
  error: shoppingListDetailsError,
  loading: shoppingListDetailsLoading,
  toggleInCart,
  addToShoppingList,
} = await useShoppingList(route.params.id, {
  useAutoListenFor: ["shoppingListChanges"],
});

const formErrors = reactive({
  name: "",
});

const addToShoppingListParameters = reactive<AddToShoppingListParameters>({
  name: "",
  quantity: 1,
  unit: UnitEnum.GRAM,
  categoryId: 1,
});

const errors = computed(() =>
  [shoppingListDetailsError.value, categoriesError.value].filter(Boolean),
);

type ProductSuggestion = Pick<Product, "id" | "createdAt" | "name"> & { unit: string };

const suggestions = ref<ProductSuggestion[]>([]);
const suggestionsOpen = ref(false);
const suggestionsLoading = ref(false);
const highlightedIndex = ref(-1);
let debounceTimer: ReturnType<typeof setTimeout> | null = null;

function openSuggestions() {
  if (suggestions.value.length > 0) {
    suggestionsOpen.value = true;
  }
}

function closeSuggestions() {
  suggestionsOpen.value = false;
  highlightedIndex.value = -1;
}

function selectSuggestion(s: ProductSuggestion) {
  try {
    addToShoppingListParameters.name = s.name;
    addToShoppingListParameters.unit = UnitEnum.valueOf(s.unit);
    closeSuggestions();
  } catch (e) {
    console.error("selectSuggestion->", e);
  }
}

async function fetchSuggestions(query: string) {
  if (!query || query.trim().length < 2) {
    suggestions.value = [];
    closeSuggestions();
    return;
  }
  suggestionsLoading.value = true;
  try {
    const response = await productClient.getProductSuggestionAsync(
      addToShoppingListParameters.name,
    );

    if ("error" in response) {
      suggestions.value = [];
      closeSuggestions();
      return;
    }
    if (!("result" in response)) {
      suggestions.value = [];
      closeSuggestions();
      return;
    }

    const result = ktToJs(response.result as KtList<ProductSuggestion>);

    suggestions.value = result || [];

    openSuggestions();
  } finally {
    suggestionsLoading.value = false;
  }
}

watch(
  () => addToShoppingListParameters.name,
  (val) => {
    if (debounceTimer) clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      fetchSuggestions(val);
    }, 250);
  },
);

function onInputKeydown(e: KeyboardEvent) {
  if (!suggestionsOpen.value && (e.key === "ArrowDown" || e.key === "ArrowUp")) {
    openSuggestions();
    return;
  }
  if (!suggestionsOpen.value) return;

  if (e.key === "ArrowDown") {
    e.preventDefault();
    highlightedIndex.value =
      suggestions.value.length === 0 ? -1 : (highlightedIndex.value + 1) % suggestions.value.length;
  } else if (e.key === "ArrowUp") {
    e.preventDefault();
    highlightedIndex.value =
      suggestions.value.length === 0
        ? -1
        : (highlightedIndex.value - 1 + suggestions.value.length) % suggestions.value.length;
  } else if (e.key === "Enter") {
    if (highlightedIndex.value >= 0 && highlightedIndex.value < suggestions.value.length) {
      e.preventDefault();
      selectSuggestion(suggestions.value[highlightedIndex.value] as any);
    }
  } else if (e.key === "Escape") {
    closeSuggestions();
  }
}

function onBlur() {
  setTimeout(() => closeSuggestions(), 100);
}

const {
  data: categories,
  error: categoriesError,
  status: categoriesStatus,
} = await useAsyncData(
  `categories`,
  async () => {
    const response = await categoryClient.getCategoriesAsync();

    if ("error" in response) {
      throw new Error(response as any);
    }

    if (!("result" in response)) {
      throw new Error("Unsupported response type: " + response.constructor.name + "");
    }

    return ktToJs(response.result as KtList<Category>);
  },
  { server: false },
);

const selectedCategory = ref<Category | null>(null);
const categoriesOpen = ref(false);

const getCategoryInitial = (name: string) => {
  if (!name) return "";

  const words = name.split(" ");
  if (words.length > 1) {
    return words
      .slice(0, 2)
      .map((w) => w[0])
      .join("")
      .toUpperCase();
  }

  return name.slice(0, 2).toUpperCase();
};

const selectCategory = (category: Category) => {
  selectedCategory.value = category;
  categoriesOpen.value = false;
  addToShoppingListParameters.categoryId = category.id;
};

async function handleAddToShoppingList(e: SubmitEvent) {
  addToShoppingList(
    {
      listId: route.params.id,
      ...addToShoppingListParameters,
    },
    () => {
      (e.currentTarget as HTMLFormElement)?.reset();
      resetAddToShoppingListParameters();
    },
    (err) => {
      formErrors.name = err.message;
    },
  );
}

function resetAddToShoppingListParameters() {
  addToShoppingListParameters.name = "";
  addToShoppingListParameters.quantity = 1;
  formErrors.name = "";
}
</script>

<template>
  <div class="card flex justify-center flex-col max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li class="px-2 inline-flex flex-row gap-2">
        <NuxtLink to="/">
          <Icon name="streamline-freehand:keyboard-arrow-return" />
        </NuxtLink>
        <Icon v-if="shoppingListDetailsLoading" class="animate-spin text-info" name="streamline-freehand:loading-star-1" />
        <DevOnly>Ilość porduktów które zostały do kupienia i dodaj zwijanie tej wstążki z dodawaniem i by lista była przewijalna a nie cały ekran</DevOnly>
      </li>
      <li class="list-row-separator">
        <form class="grid grid-cols-[80px_minmax(0,_auto)_45px]" @submit.prevent="handleAddToShoppingList">
          <button class="btn btn-ghost btn-square ">
            <Icon name="streamline-freehand:add-sign-bold" />
          </button>
          <div class="relative col-span-2">
            <input
                v-model="addToShoppingListParameters.name"
                class="input input-ghost w-full"
                placeholder="Nazwa produktu"
                required
                type="text"
                autocomplete="off"
                role="combobox"
                aria-autocomplete="list"
                :aria-expanded="suggestionsOpen"
                aria-controls="suggestions-list"
                :aria-activedescendant="highlightedIndex >= 0 ? `suggestion-${highlightedIndex}` : undefined"
                @focus="openSuggestions()"
                @blur="onBlur"
                @keydown="onInputKeydown"
            />

            <ul
                v-if="suggestionsOpen"
                id="suggestions-list"
                class="border-1 w-full absolute top-full left-0 right-0 mt-1 z-20 menu bg-base-100 rounded-box shadow-lg max-h-64 overflow-auto p-2"
                role="listbox"
            >
              <li v-if="suggestionsLoading" class="disabled" role="presentation">
                <span class="loading loading-spinner loading-sm"></span>
                Ładowanie…
              </li>

              <li
                  v-for="(suggestion, idx) in suggestions"
                  v-else-if="suggestions.length > 0"
                  :id="`suggestion-${idx}`"
                  :key="suggestion.id || suggestion.name + idx"
                  role="option"
                  class="inline-flex flex-row justify-between items-center"
                  :class="{ 'active': idx === highlightedIndex }"
                  :aria-selected="idx === highlightedIndex"
                  @click="selectSuggestion(suggestion)"
                  @mouseenter="highlightedIndex = idx"
                  @mousedown.prevent
              >
                <span>{{ suggestion.name }}</span>
                <span class="badge badge-ghost badge-sm">{{ suggestion.unit || 'szt.' }}</span>
              </li>

              <li v-else-if="!suggestionsLoading && suggestions.length === 0" class="disabled" role="presentation">
                <span class="opacity-60">Brak sugestii</span>
              </li>
            </ul>
          </div>
          <input
              v-model="addToShoppingListParameters.quantity"
              class="input input-ghost"
              min="1"
              required
              type="number"
          />
          <select v-model="addToShoppingListParameters.unit" class="select select-ghost col-span-2 w-full">
            <option disabled selected>Wybierz jednostkę</option>
            <option v-for="unit in units" :key="unit.name" :value="unit">{{ unit.name }}</option>
          </select>
          <div class="relative col-span-3">
            <button
                type="button"
                class="btn btn-ghost w-full justify-between"
                @click="categoriesOpen = !categoriesOpen"
                @blur="categoriesOpen = false"
            >
              <div v-if="selectedCategory" class="flex items-center gap-2">
                <span
                    class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-sm"
                    :style="{ backgroundColor: `#${selectedCategory.color}` }"
                >
                    {{ getCategoryInitial(selectedCategory.name) }}
                  </span>
                <span>{{ selectedCategory.name }}</span>
              </div>
              <span v-else class="opacity-60">Wybierz kategorię</span>
              <Icon name="mdi:chevron-down" class="ml-auto" />
            </button>

            <ul
                v-if="categoriesOpen"
                class="border-1 w-full absolute top-full left-0 right-0 mt-1 z-20 bg-base-100 rounded-box shadow-lg max-h-64 overflow-auto p-2"
                role="listbox"
            >
              <li v-if="categoriesStatus === 'pending'" class="disabled" role="presentation">
                <span class="loading loading-spinner loading-sm"></span>
                Ładowanie…
              </li>
              <li
                  v-for="category in categories"
                  :key="category.id"
                  role="option"
                  :class="{ 'active': addToShoppingListParameters.categoryId === category.id }"
                  :aria-selected="addToShoppingListParameters.categoryId === category.id"
                  @mousedown.prevent
                  class="inline-flex flex-row w-full items-center gap-3 px-3 py-2 rounded-lg cursor-pointer hover:bg-base-200"
                  @click="selectCategory(category as Category)"
              >
                  <span
                      class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-sm"
                      :style="{ backgroundColor: `#${category.color}` }"
                  >
                    {{ getCategoryInitial(category.name) }}
                  </span>
                  <span>{{ category.name }}</span>
              </li>
            </ul>
          </div>
        </form>
      </li>
      <li v-if="categoriesWithProducts.length" v-for="categoryWithProducts in categoriesWithProducts" :key="categoryWithProducts.category.id" class="category-list">
        <span class="inline-flex items-center gap-2">
          <span
              class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-sm"
              :style="{ backgroundColor: `#${categoryWithProducts.category.color}` }"
          >
              {{ getCategoryInitial(categoryWithProducts.category.name) }}
            </span>
          <span>{{ categoryWithProducts.category.name }}</span>
        </span>
        <ul class="list">
          <li
              v-for="product in categoryWithProducts.products"
              v-if="categoryWithProducts.products?.length"
              :key="product.id"
              :class="{ 'line-through': product.inCart}"
              class="list-row"
              @click="toggleInCart( product.id )"
          >
            <span class="list-col-grow">{{ product.name }}</span>
            <span>{{ product.quantity }} {{ product.unit }}</span>
          </li>
          <li v-else class="list-row">Brak produktów w kategorii</li>
        </ul>
      </li>
      <li v-else class="list-row">Brak produktów na liście</li>
    </ul>
    <div v-if="errors.length" class="flex flex-col gap-1"><span class="text-error" v-for="error in errors">{{ error }}</span></div>
  </div>
</template>

<style>
.list-row-separator {
  margin-bottom: var(--radius-box);
  border-bottom: var(--border) solid;
  border-color: var(--color-base-content);
  @supports (color: color-mix(in lab, red, red)) {
    border-color: color-mix(in oklab, var(--color-base-content) 5%, transparent);
  }
  & > * {
    margin-bottom: var(--radius-box);
  }
}
.category-list:not(:last-of-type) {
  margin-bottom: var(--radius-box);
}
</style>