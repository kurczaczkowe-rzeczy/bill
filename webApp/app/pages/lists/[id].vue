<script lang="ts" setup>
import type { Category, CategoryWithProducts } from '@bill/Bill-shoppingList'

import SearchCategory from '#layers/category/components/SearchCategory.vue'
import SearchProduct from '#layers/product/components/SearchProduct.vue'
import SearchUnit from '#layers/product/components/SearchUnit.vue'
import { INITIAL_DISPLAY_UNITS, useDisplayUnits } from '#layers/product/composables/useDisplayUnits'
import type { ProductSuggestion } from '#layers/product/types'
import BaseButton from '#layers/ui/components/BaseButton.vue'
import BaseCollapse from '~/components/BaseCollapse.vue'
import CategoryWithProductList from '~/components/CategoryWithProductList.vue'
import { type AddToShoppingListParameters, useShoppingList } from '~/composables/useShoppingList'
import { getStringParam } from '~/utils/getStringParam'

definePageMeta({
  nav: "shopping-lists",
});

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
  baseUnit: INITIAL_DISPLAY_UNITS[0],
  categoryId: "00000000-0000-0000-0000-000000000000",
});

const errors = computed(() =>
  [shoppingListDetailsError.value, categoriesError.value].filter(Boolean),
);

function selectSuggestion(s: ProductSuggestion) {
  try {
    addToShoppingListParameters.name = s.name;
    addToShoppingListParameters.baseUnit = s.baseUnit;
  } catch (e) {
    console.error("selectSuggestion->", e);
  }
}

const { data: categories, error: categoriesError } = useGetCategories();

const selectCategory = (category: Category) => {
  addToShoppingListParameters.categoryId = category.id;
};

async function handleAddToShoppingList(e: Event) {
  addToShoppingList(
    {
      listId: route.params.id,
      ...addToShoppingListParameters,
    },
    () => {
      const target = (e.currentTarget as HTMLFormElement) || (e.target as HTMLFormElement | null);

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

function handleToggleInCart(productId: string) {
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
  return suggestion.name === query && suggestion.baseUnit === addToShoppingListParameters.baseUnit;
}

function useCollapsedAddForm(listId: string) {
  const collapsedAddFormListIds = useCookie<Set<string>>(COLLAPSED_ADD_FORM_LIST_IDS, {
    default: () => new Set(),
    watch: true,
    encode: (set) => JSON.stringify([...set]),
    decode: (str) => {
      try {
        return new Set(JSON.parse(str ?? ""));
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
    <div class="card-body bg-base-100 rounded-box shadow-md w-full overflow-y-auto gap-4">
      <BaseCollapse v-model:open="isAddProductFormHidden" :toggleable="false" class="shrink-0">
        <template #summary>
          <div class="grid items-center gap-4 grid-cols-[45px_1rem_auto_45px] text-base">
            <BaseButton circle class="relative" to="/">
              <Icon name="streamline-freehand:keyboard-arrow-return" />
            </BaseButton>
            <Icon
              :class="{'invisible': !shoppingListDetailsLoading }"
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
            class="list-row-separator grid grid-cols-[45px_45px_auto_auto_auto] pt-4"
            @submit.prevent="handleAddToShoppingList"
          >
            <BaseButton circle type="submit" class="col-span-1">
              <Icon name="streamline-freehand:add-sign-bold" />
            </BaseButton>
            <SearchProduct
              v-model="addToShoppingListParameters.name"
              :match-by="matchProductSuggestionBy"
              wrapperClass="col-span-4"
              @select="selectSuggestion"
            />
            <BaseNumberInput
              v-model="addToShoppingListParameters.quantity"
              class="col-span-2"
              min="1"
              name="quantity"
              required
            />
            <SearchUnit v-model="addToShoppingListParameters.baseUnit.name" class="col-span-3" name="unit" />
            <SearchCategory
              @select="selectCategory"
              wrapperClass="col-span-full"
            />
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
            :category-with-products="categoryWithProducts as unknown as CategoryWithProducts"
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
  gap: var(--radius-box);
  border-bottom: var(--border) solid;
  border-color: var(--color-base-content);
  @supports (color: color-mix(in lab, red, red)) {
    border-color: color-mix(in oklab, var(--color-base-content) 5%, transparent);
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