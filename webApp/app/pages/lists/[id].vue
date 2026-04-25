<script lang="ts" setup>
import type {
  Category,
  CategoryWithProducts,
  DisplayUnit,
  Product,
} from "@bill/Bill-shoppingList";
import BaseMatchEmphasis from "@ui/components/BaseMatchEmphasis.vue";

import BaseAutocomplete from "~/components/BaseAutocomplete.vue";
import BaseCollapse from "~/components/BaseCollapse.vue";
import CategoryDescriptor from "~/components/CategoryDescriptor.vue";
import CategoryWithProductList from "~/components/CategoryWithProductList.vue";
import { INITIAL_DISPLAY_UNITS, useDisplayUnits } from '~/composables/useDisplayUnits'
import { useProductClient } from "~/composables/useProductClient";
import { type AddToShoppingListParameters, useShoppingList } from "~/composables/useShoppingList";
import { getStringParam } from "~/utils/getStringParam";
import type { KtList } from "~/utils/ktListToArray";
import { ktToJs } from "~/utils/ktToJs";
import { useGetCategories } from "~~/layers/category/composables/useGetCategories";
import BaseButton from "~~/layers/ui/components/BaseButton.vue";

const productClient = useProductClient();

const COLLAPSED_ADD_FORM_LIST_IDS = "collapsedAddFormListIds";

const route = useRoute();

const {
  isCollapsed: isAddProductFormHidden,
  toggle: toggleAddForm,
  hasEverToggled: hasEverToggledAddForm,
} = useCollapsedAddForm(getStringParam(route.params.id));

const { data: displayUnits } = useDisplayUnits();

const {
  categoriesWithProducts,
  error: shoppingListDetailsError,
  loading: shoppingListDetailsLoading,
  toggleInCart,
  addToShoppingList,
  deleteProductFromShoppingList,
  switchProductCategory,
  shoppingListDetails,
  refresh,
} = useShoppingList(route.params.id, {
  useAutoListenFor: ["shoppingListChanges"],
});

const leftToBuy = computed(() =>
  shoppingListDetails.value.reduce((prev, curr) => prev + Number(!curr.inCart), 0),
);

const formErrors = reactive({
  name: "",
});

const addToShoppingListParameters = reactive<AddToShoppingListParameters>({
  name: "",
  quantity: 1,
  unit: INITIAL_DISPLAY_UNITS[0],
  categoryId: 1n,
});

const errors = computed(() =>
  [shoppingListDetailsError.value, categoriesError.value].filter(Boolean),
);

interface ProductSuggestion extends Omit<Product, 'unit'> {
  unit: DisplayUnit
}

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
    addToShoppingListParameters.unit = s.unit;
    closeSuggestions();
  } catch (e) {
    console.error("selectSuggestion->", e);
  }
}

async function fetchSuggestions(query: string) {
  // ToDo: jak już wcześniej nie znaleziono i dopisujesz litery to weź nie puszczaj rq bo to nie ma sensu
  // ToDo 2: Najlepiej jak se zrobisz testy pod to bo trzeba kilka warunków ogarnąć które i tak zapomnisz :D
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
    const mappedSuggestions = result.map((suggestion) => {
      const unit =
        displayUnits.value?.find(
          ({ baseUnit, multiplier }) => baseUnit === suggestion.unit && multiplier === 1,
        ) ?? new DisplayUnit(suggestion.unit, suggestion.unit, suggestion.unit, 1);

      return {
        ...suggestion,
        unit,
      } as ProductSuggestion;
    });

    suggestions.value = mappedSuggestions || [];

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
  if (!hasEverToggledAddForm.value && !isAddProductFormHidden.value) {
    toggleAddForm();
  }

  toggleInCart(productId);
}

function handleVisibilityChange() {
  if (document.visibilityState === "visible") {
    refresh();
  }
}

onMounted(() => {
  // ToDo: If ls is empty and shopping list has product in cart but they isn't already fetched, form stays open.
  //  Probably using cookies solves it.
  const hasAnyInCart = shoppingListDetails.value.some((product) => product.inCart);

  if (hasAnyInCart && import.meta.client && !isAddProductFormHidden.value) {
    toggleAddForm();
  }

  document.addEventListener("visibilitychange", handleVisibilityChange);
});

onUnmounted(() => {
  document.removeEventListener("visibilitychange", handleVisibilityChange);
});

function matchProductSuggestionBy(suggestion: ProductSuggestion, query: string): boolean {
  return suggestion.name === query && suggestion.unit === addToShoppingListParameters.unit;
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
      <BaseCollapse v-model:open="isAddProductFormHidden" :toggleable="false" class="shrink-0">
        <template #summary>
          <div class="grid items-center gap-2 grid-cols-[45px_1rem_auto_45px] text-base">
            <BaseButton circle class="relative" to="/">
              <Icon name="streamline-freehand:keyboard-arrow-return" />
            </BaseButton>
            <Icon
              :class="shoppingListDetailsLoading ? '' : 'invisible'"
              class="animate-spin text-info"
              name="streamline-freehand:loading-star-1"
            />
            <span class="justify-self-end">Pozostało: {{ leftToBuy }}</span>
            <BaseButton circle @click="toggleAddForm">
              <Icon
                :class="isAddProductFormHidden ? 'rotate-270' : 'rotate-90'"
                class="transition-transform"
                name="streamline-freehand:move-rectangle-left"
              />
            </BaseButton>
          </div>
        </template>
        <template #content>
          <form
            class="list-row-separator grid grid-cols-[80px_100px_minmax(0,auto)_45px]"
            @submit.prevent="handleAddToShoppingList"
          >
            <BaseButton circle>
              <Icon name="streamline-freehand:add-sign-bold" />
            </BaseButton>
            <BaseAutocomplete
              v-model="addToShoppingListParameters.name"
              :is-loading="suggestionsLoading"
              :match-by="matchProductSuggestionBy"
              :suggestions="suggestions"
              label-key="name"
              list-id="suggestions"
              name="product"
              placeholder="Nazwa produktu"
              wrapperClass="col-span-3"
              @search="fetchSuggestions"
              @select="selectSuggestion"
            >
              <template #item="{ item: suggestion }">
                <span class="list-col-grow">
                  <BaseMatchEmphasis
                    :text="suggestion.name"
                    :query="addToShoppingListParameters.name"
                  />
                </span>
                <span class="badge badge-ghost badge-sm">{{ suggestion.unit.shortName || 'szt.' }}</span>
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
            <select v-model="addToShoppingListParameters.unit" class="select select-ghost w-full" name="unit">
              <option disabled selected>Wybierz jednostkę</option>
              <option v-for="unit in displayUnits" :key="unit.name" :value="unit">{{ unit.shortName }}</option>
            </select>

            <BaseAutocomplete
              v-model="categoryNameQuery"
              :is-loading="categoriesStatus === 'pending'"
              :suggestions="categoriesFilterDownByQuery ?? []"
              label-key="name"
              list-id="categories"
              name="category"
              wrapperClass="col-span-2"
              @select="selectCategory as any"
            >
              <template #input="{ value: query, listId, handleKeydown, handleClick, handleInput, bindFieldRef, attrs }">
                <div :ref="bindFieldRef as any" class="flex items-center gap-2 input input-ghost w-full">
                  <CategoryDescriptor
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
                  </CategoryDescriptor>
                  <Icon class="autocomplete-arrow" name="mdi:chevron-down" />
                </div>
              </template>
              <template #item="{ item: selectedCategory }">
                <CategoryDescriptor :name="selectedCategory.name" :color="selectedCategory.color" />
              </template>
            </BaseAutocomplete>
          </form>
        </template>
      </BaseCollapse>
      <ul class="list category-lists">
        <li
          v-for="categoryWithProducts in categoriesWithProducts"
          v-if="categoriesWithProducts.length"
          :key="categoryWithProducts.category.id.toString()"
          class="category-list"
        >
          <CategoryWithProductList
            :categories="categories ?? []"
            :category-with-products="categoryWithProducts as CategoryWithProducts"
            :on-delete-product="deleteProductFromShoppingList"
            :on-toggle-in-cart="handleToggleInCart"
            :switch-product-category="switchProductCategory"
          />
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

.category-lists {
  margin-inline: calc(var(--card-p, 1.5rem) * -1);
  padding-inline: var(--card-p, 1.5rem);
  overflow: auto;
  justify-items: flex-start;
  gap: var(--radius-box);
}
</style>