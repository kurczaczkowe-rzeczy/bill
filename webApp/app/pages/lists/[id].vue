<script lang="ts" setup>
import {
  type Category,
  type Product,
  type ShoppingListDetails,
  UnitEnum,
} from "@bill/Bill-shoppingList";
import type { DraggableEvent } from "vue-draggable-plus";

import { type AddToShoppingListParameters, useShoppingList } from "~/composables/useShoppingList";
import { productClient } from "~/constants";
import CategoryListItem from "~/pages/lists/CategoryListItem.vue";
import { getStringParam } from "~/utils/getStringParam";
import { isNil } from "~/utils/isNil";
import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";
import { useGetCategories } from "~~/layers/category/composables/useGetCategories";

const ITEM_CHOOSE_TIMESTAMP_TIMEOUT = 150;
const COLLAPSED_ADD_FORM_LIST_IDS = "collapsedAddFormListIds";

const route = useRoute();

const {
  isCollapsed: isAddProductFormHidden,
  toggle: toggleAddForm,
  hasEverToggled: hasEverToggledAddForm,
} = useCollapsedAddForm(getStringParam(route.params.id));

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
} = useShoppingList(route.params.id, {
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

    const category = categories.value?.find(
      (c) => c.id === BigInt(evt.to.parentElement?.dataset.categoryId ?? -1),
    );

    if (!category) {
      return;
    }

    switchProductCategory(evt.data.id, category);
    // Timestamp is set to prevent calling whole click event when user chooses an element to reorder.
    // So I need to reset it here to make it possible to call click event.
    setTimeout(() => {
      itemChooseTimeStamp.value = null;
    }, ITEM_CHOOSE_TIMESTAMP_TIMEOUT);
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
  categoryId: 1n,
});

const errors = computed(() =>
  [shoppingListDetailsError.value, categoriesError.value].filter(Boolean),
);

type ProductSuggestion = Product;

const suggestions = ref<ProductSuggestion[]>([]);
const suggestionsOpen = ref(false);
const suggestionsLoading = ref(false);
const highlightedIndex = ref(-1);

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
    addToShoppingListParameters.unit = UnitEnum.valueOf(s.unit.name);
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

    const result = ktToJs(response.result as KtList<Product>) as Product[];

    suggestions.value = result || [];

    openSuggestions();
  } finally {
    suggestionsLoading.value = false;
  }
}

const { data: categories, error: categoriesError, status: categoriesStatus } = useGetCategories();

const selectedCategory = ref<Category | null>(null);
const categoryNameQuery = ref("");
const categoriesFilterDownByQuery = computed(() => {
  if (!categoryNameQuery.value || categoryNameQuery.value === selectedCategory.value?.name) {
    return categories.value;
  }

  return categories.value?.filter(({ name }) =>
    new RegExp(categoryNameQuery.value, "i").test(name),
  );
});

const selectCategory = (category: Category) => {
  selectedCategory.value = category;
  addToShoppingListParameters.categoryId = BigInt(category.id);
  categoryNameQuery.value = category.name;
};

async function handleAddToShoppingList(e: Event) {
  addToShoppingList(
    {
      listId: route.params.id,
      ...addToShoppingListParameters,
    },
    () => {
      const target = (e.currentTarget as HTMLFormElement) || (e.target as HTMLFormElement | null);
      target?.reset();
      (target?.elements.namedItem("product") as HTMLInputElement)?.focus();
      resetAddToShoppingListParameters();
    },
    (err) => {
      formErrors.name = err.message;
    },
  ).catch((err) => {
    formErrors.name = err && "message" in err ? err.message : "Unknown error";
  });
}

function resetAddToShoppingListParameters() {
  addToShoppingListParameters.name = "";
  addToShoppingListParameters.quantity = 1;
  formErrors.name = "";
}

function handleToggleInCart(productId: bigint) {
  if (
    itemChooseTimeStamp.value &&
    Date.now() - itemChooseTimeStamp.value > ITEM_CHOOSE_TIMESTAMP_TIMEOUT
  ) {
    return;
  }

  if (!hasEverToggledAddForm.value && !isAddProductFormHidden.value) {
    toggleAddForm();
  }

  toggleInCart(productId);
}

onMounted(() => {
  // ToDo: If ls is empty and shopping list has product in cart but they isn't already fetched, form stays open.
  //  Probably using cookies solves it.
  const hasAnyInCart = shoppingListDetails.value.some((product) => product.inCart);

  if (hasAnyInCart && import.meta.client && !isAddProductFormHidden.value) {
    toggleAddForm();
  }
});

function matchProductSuggestionBy(suggestion: ProductSuggestion, query: string): boolean {
  return (
    suggestion.name === query && suggestion.unit.name === addToShoppingListParameters.unit.name
  );
}

function useCollapsedAddForm(listId: string) {
  const collapsedAddFormListIds = useCookie<Set<string>>(COLLAPSED_ADD_FORM_LIST_IDS, {
    default: () => new Set(),
    watch: true,
    encode: (set) => JSON.stringify([...set]),
    decode: (str) => {
      try {
        return new Set(JSON.parse(str));
      } catch {
        return new Set();
      }
    },
  });

  const isCollapsed = computed(() => collapsedAddFormListIds.value.has(listId));
  const hasEverToggled = ref(false);

  function toggle() {
    const newSet = new Set(collapsedAddFormListIds.value);

    if (newSet.has(listId)) {
      newSet.delete(listId);
    } else {
      newSet.add(listId);
    }

    collapsedAddFormListIds.value = newSet;
    hasEverToggled.value = true;
  }

  return {
    isCollapsed: readonly(isCollapsed),
    hasEverToggled: readonly(hasEverToggled),
    toggle,
  };
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
            :class="isAddProductFormHidden ? 'rotate-270' : 'rotate-90'"
            class="transition-transform"
            name="streamline-freehand:move-rectangle-left"
          />
        </button>
      </div>
      <transition name="collapse">
        <form
          v-show="!isAddProductFormHidden"
          class="list-row-separator grid grid-cols-[80px_minmax(0,_auto)_45px]"
          @submit.prevent="handleAddToShoppingList"
        >
          <button class="btn btn-ghost btn-circle">
            <Icon name="streamline-freehand:add-sign-bold" />
          </button>
          <BaseAutocomplete
            v-model="addToShoppingListParameters.name"
            :is-loading="suggestionsLoading"
            :match-by="matchProductSuggestionBy"
            :suggestions="suggestions"
            label-key="name"
            list-id="suggestions"
            name="product"
            placeholder="Nazwa produktu"
            wrapperClass="col-span-2"
            @search="fetchSuggestions"
            @select="selectSuggestion"
          >
            <template #item="{ item: suggestion }">
              <span class="list-col-grow">{{ suggestion.name }}</span>
              <span class="badge badge-ghost badge-sm">{{ suggestion.unit || 'szt.' }}</span>
            </template>
          </BaseAutocomplete>
          <input
            v-model="addToShoppingListParameters.quantity"
            class="input input-ghost"
            min="1"
            name="quantity"
            required
            type="number"
          />
          <select v-model="addToShoppingListParameters.unit" class="select select-ghost col-span-2 w-full" name="unit">
            <option disabled selected>Wybierz jednostkę</option>
            <option v-for="unit in units" :key="unit.name" :value="unit">{{ unit.name }}</option>
          </select>

          <BaseAutocomplete
            v-model="categoryNameQuery"
            :is-loading="categoriesStatus === 'pending'"
            :suggestions="categoriesFilterDownByQuery ?? []"
            label-key="name"
            list-id="categories"
            name="category"
            wrapperClass="col-span-3"
            @select="selectCategory as any"
          >
            <template #input="{ value: query, listId, handleKeydown, handleClick, handleInput, bindFieldRef, attrs }">
              <div :ref="bindFieldRef as any" class="flex items-center gap-2 input input-ghost w-full">
                <CategoryListItem
                  :color="selectedCategory?.color ?? '323232'"
                  :name="selectedCategory?.name ?? query"
                >
                  <template #label>
                    <input
                      :aria-controls="listId"
                      :value="query"
                      aria-autocomplete="list"
                      autocomplete="off"
                      placeholder="Wybierz kategorię"
                      role="combobox"
                      type="text"
                      v-bind="attrs"
                      @click="handleClick"
                      @input="handleInput"
                      @keydown="handleKeydown"
                    />
                  </template>
                </CategoryListItem>
                <Icon class="autocomplete-arrow" name="mdi:chevron-down" />
              </div>
            </template>
            <template #item="{ item: selectedCategory }">
              <CategoryListItem :="selectedCategory" />
            </template>
          </BaseAutocomplete>
        </form>
      </transition>
      <ul class="list category-lists">
        <li
          v-for="categoryWithProducts in categoriesWithProducts"
          v-if="categoriesWithProducts.length"
          :key="categoryWithProducts.category.id.toString()"
          class="category-list"
        >
          <CategoryListItem :="categoryWithProducts.category" />
          <DraggableList
            :data-category-id="categoryWithProducts.category.id"
            :itemProps="(product) => ({
              class: { 'line-through': product.inCart },
              onClick: () => handleToggleInCart( product.id )
            })"
            :items="categoryWithProducts.products as ShoppingListDetails[]"
            :="draggableOptions"
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
          {{ error }}
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