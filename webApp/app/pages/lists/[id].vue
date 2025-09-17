<script lang="ts" setup>
import {
  type Category,
  type Product,
  type ShoppingListDetails,
  UnitEnum,
} from "@bill/Bill-shoppingList";
import type { DraggableEvent } from "vue-draggable-plus";

import {
  type AddToShoppingListParameters,
  useShoppingList,
} from "~/composables/useShoppingListClient";
import { categoryClient, productClient } from "~/constants";
import { isNil } from "~/utils/isNil";
import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";

const route = useRoute();

const hidden = ref(false);

function toggleAddForm(): void {
  hidden.value = !hidden.value;
}

const units = UnitEnum.values();

const {
  categoriesWithProducts,
  error: shoppingListDetailsError,
  loading: shoppingListDetailsLoading,
  toggleInCart,
  addToShoppingList,
  deleteProductFromShoppingList,
  switchProductCategory,
  shoppingListDetails,
} = await useShoppingList(route.params.id, {
  useAutoListenFor: ["shoppingListChanges"],
});

const leftToBuy = computed(() =>
  shoppingListDetails.value.reduce((prev, curr) => prev + Number(!curr.inCart), 0),
);

const itemChooseTimeStamp = ref<number | null>(null);

const draggableOptions = {
  group: "shopping-list",
  animation: 200,
  handle: ".handle",
  onEnd: (evt: DraggableEvent<ShoppingListDetails>) => {
    if (isNil(evt.data)) {
      return;
    }

    const category = categories.value?.find((c) => c.id === Number(evt.to.dataset.categoryId));

    if (!category) {
      return;
    }
    switchProductCategory(evt.data.id, category as Category);
  },
  forceFallback: true,
  fallbackClass: "hidden",
  onChoose: (_evt: DraggableEvent<ShoppingListDetails>) => {
    itemChooseTimeStamp.value = Date.now();
  },
};

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
    if (debounceTimer) {
      clearTimeout(debounceTimer);
    }
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
  if (!suggestionsOpen.value) {
    return;
  }

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
      selectSuggestion(suggestions.value[highlightedIndex.value] as ProductSuggestion);
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
      throw new Error(response as unknown as string);
    }

    if (!("result" in response)) {
      throw new Error(`Unsupported response type: ${response.constructor.name}`);
    }

    return ktToJs(response.result as KtList<Category>);
  },
  { server: false },
);

const selectedCategory = ref<Category | null>(null);
const categoriesOpen = ref(false);

const getCategoryInitial = (name: string) => {
  if (!name) {
    return "";
  }

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

async function handleAddToShoppingList(e: Event) {
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

function handleToggleInCart(productId: number) {
  if (itemChooseTimeStamp.value && Date.now() - itemChooseTimeStamp.value > 150) {
    return;
  }

  toggleInCart(productId);
}
</script>

<template>
  <div class="card flex flex-col max-w-xl m-auto max-h-screen">
    <div class="card-body bg-base-100 rounded-box shadow-md w-full overflow-y-auto">
      <div class="grid items-center gap-2 grid-cols-[45px_1rem_auto_45px] text-base">
        <NuxtLink class="btn btn-ghost btn-circle relative" to="/">
          <Icon name="streamline-freehand:keyboard-arrow-return" />
        </NuxtLink>
        <Icon
          :class="shoppingListDetailsLoading ? '' : 'invisible'"
          class="animate-spin text-info"
          name="streamline-freehand:loading-star-1"
        />
        <span class="justify-self-end">Pozostało: {{ leftToBuy }}</span>
        <button class="btn btn-ghost btn-circle" @click="toggleAddForm">
          <Icon
            :class="hidden ? 'rotate-270' : 'rotate-90'"
            class="transition-transform"
            name="streamline-freehand:move-rectangle-left"
          />
        </button>
      </div>
      <transition name="collapse">
        <form
          v-show="!hidden"
          class="list-row-separator grid grid-cols-[80px_minmax(0,_auto)_45px]"
          @submit.prevent="handleAddToShoppingList"
        >
          <button class="btn btn-ghost btn-circle">
            <Icon name="streamline-freehand:add-sign-bold" />
          </button>
          <div class="relative col-span-2">
            <input
              v-model="addToShoppingListParameters.name"
              :aria-activedescendant="highlightedIndex >= 0 ? `suggestion-${highlightedIndex}` : undefined"
              :aria-expanded="suggestionsOpen"
              aria-autocomplete="list"
              aria-controls="suggestions-list"
              autocomplete="off"
              class="input input-ghost w-full"
              placeholder="Nazwa produktu"
              required
              role="combobox"
              type="text"
              @blur="onBlur"
              @focus="openSuggestions()"
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
                :aria-selected="idx === highlightedIndex"
                :class="{ 'active': idx === highlightedIndex }"
                class="inline-flex flex-row justify-between items-center"
                role="option"
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
              class="btn btn-ghost w-full justify-between"
              type="button"
              @blur="categoriesOpen = false"
              @click="categoriesOpen = !categoriesOpen"
            >
              <div v-if="selectedCategory" class="flex items-center gap-2">
                <span
                  :style="{ backgroundColor: `#${selectedCategory.color}` }"
                  class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-sm"
                >
                  {{ getCategoryInitial( selectedCategory.name ) }}
                </span>
                <span>{{ selectedCategory.name }}</span>
              </div>
              <span v-else class="opacity-60">Wybierz kategorię</span>
              <Icon class="ml-auto" name="mdi:chevron-down" />
            </button>

            <ul
              v-if="categoriesOpen"
              class="border-1 w-full absolute top-full left-0 right-0 mt-1 z-20 bg-base-100 rounded-box shadow-lg max-h-64 overflow-auto p-2"
              role="listbox"
            >
              <li v-if="categoriesStatus === 'pending'" class="disabled" role="presentation">
                <span class="loading loading-spinner loading-sm" />
                Ładowanie…
              </li>
              <li
                v-for="category in categories"
                :key="category.id"
                :aria-selected="addToShoppingListParameters.categoryId === category.id"
                :class="{ 'active': addToShoppingListParameters.categoryId === category.id }"
                class="inline-flex flex-row w-full items-center gap-3 px-3 py-2 rounded-lg cursor-pointer hover:bg-base-200"
                role="option"
                @click="selectCategory(category as Category)"
                @mousedown.prevent
              >
                <span
                  :style="{ backgroundColor: `#${category.color}` }"
                  class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-sm"
                >
                  {{ getCategoryInitial( category.name ) }}
                </span>
                <span>{{ category.name }}</span>
              </li>
            </ul>
          </div>
        </form>
      </transition>
      <ul class="list category-lists">
        <li
          v-for="categoryWithProducts in categoriesWithProducts"
          v-if="categoriesWithProducts.length"
          :key="categoryWithProducts.category.id"
          class="category-list"
        >
          <span class="inline-flex items-center gap-2">
            <span
              :style="{ backgroundColor: `#${categoryWithProducts.category.color}` }"
              class="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold text-white shadow-sm"
            >
              {{ getCategoryInitial( categoryWithProducts.category.name ) }}
            </span>
            <span>{{ categoryWithProducts.category.name }}</span>
          </span>
          <DraggableList
            :data-category-id="categoryWithProducts.category.id"
            :draggableOptions="draggableOptions as any"
            :itemProps="(product) => ({
              class: { 'line-through': product.inCart },
              onClick: () => handleToggleInCart( product.id )
            })"
            :items="categoryWithProducts.products"
          >
            <template #item="{ item: product }">
              <span class="list-col-grow">{{ product.name }} </span>
              <button
                class="btn btn-ghost btn-sm handle absolute px-2 py-4 mx-1 -my-4"
                @click.stop
              >
                <Icon name="streamline-freehand:data-transfer-vertical" />
              </button>
              <span>{{ product.quantity }} {{ product.unit }}</span>
              <button @click.stop="deleteProductFromShoppingList(product.id)">
                <Icon name="streamline-freehand:remove-delete-sign-bold" />
              </button>
            </template>
            <template #empty>Brak produktów w kategorii</template>
          </DraggableList>
        </li>
        <li v-else class="list-row">Brak produktów na liście</li>
      </ul>
      <div v-if="errors.length" class="flex flex-col gap-1">
        <span v-for="error in errors" class="text-error">
          {{ error }}\
        </span>
      </div>
    </div>
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

.handle {
  left: calc(var(--card-p, 1.5rem) * -1);
  height: fit-content;
}

.category-lists {
  margin-inline: calc(var(--card-p, 1.5rem) * -1);
  padding-inline: var(--card-p, 1.5rem);
  overflow: auto;
  justify-items: flex-start;
}

.category-list:not(:last-of-type) {
  margin-bottom: var(--radius-box);
}

.collapse-enter-active,
.collapse-leave-active {
  transition: all 0.3s ease;
  max-height: 500px;
  overflow-y: hidden;
}

.collapse-enter-from,
.collapse-leave-to {
  max-height: 0;
  opacity: 0;
  padding-top: 0;
  padding-bottom: 0;
}
</style>