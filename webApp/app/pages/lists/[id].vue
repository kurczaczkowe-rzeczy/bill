<script lang="ts" setup>
import { ShoppingListClient, type ShoppingListDetails, UnitEnum, ProductClient, Product } from '@bill/Bill-shoppingList';

import type { KtList } from '~/utils/ktListToArray';
import { ktToJs } from '~/utils/ktToJs';

const route = useRoute();

const shoppingListClient = new ShoppingListClient();
const productClient = new ProductClient();

const units = UnitEnum.values();

const { data, error, refresh, status } = await useAsyncData( `shoppingListDetails:${route.params.id}`, async () => {
  if (isNaN(Number(route.params.id))) {
    return []
  }
  const response = await shoppingListClient.getShoppingListAsync( route.params.id );

  if ( 'error' in response ) {
    throw new Error( response as any );
  }

  if ( !('result' in response) ) {
    throw new Error( 'Unsupported response type: ' + response.constructor.name + '' );
  }

  return ktToJs( response.result as KtList<ShoppingListDetails> );
} );

const errors = reactive( {
  name: '',
} );

interface AddToShoppingListParameters {
  name: string;
  quantity: number;
  unit: UnitEnum;
  categoryId: number;
}

const addToShoppingListParameters = reactive<AddToShoppingListParameters>( {
  name: '',
  quantity: 1,
  unit: UnitEnum.GRAM,
  categoryId: 1,
} );

type ProductSuggestion = Pick<Product, 'id' | 'createdAt' | 'name'> & { unit: string };

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
  addToShoppingListParameters.name = s.name;
  addToShoppingListParameters.unit = UnitEnum.valueOf( s.unit );
  closeSuggestions();
}

async function fetchSuggestions(query: string) {
  if (!query || query.trim().length < 2) {
    suggestions.value = [];
    closeSuggestions();
    return;
  }
  suggestionsLoading.value = true;
  try {
    const response = await productClient.getProductSuggestionAsync(addToShoppingListParameters.name);

    if ('error' in response) {
      suggestions.value = [];
      closeSuggestions();
      return;
    }
    if (!('result' in response)) {
      suggestions.value = [];
      closeSuggestions();
      return;
    }

    const result = ktToJs(response.result as KtList<ProductSuggestion>);

    suggestions.value = (result || [])

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
  }
);

function onInputKeydown(e: KeyboardEvent) {
  if (!suggestionsOpen.value && (e.key === 'ArrowDown' || e.key === 'ArrowUp')) {
    openSuggestions();
    return;
  }
  if (!suggestionsOpen.value) return;

  if (e.key === 'ArrowDown') {
    e.preventDefault();
    highlightedIndex.value =
      suggestions.value.length === 0
        ? -1
        : (highlightedIndex.value + 1) % suggestions.value.length;
  } else if (e.key === 'ArrowUp') {
    e.preventDefault();
    highlightedIndex.value =
      suggestions.value.length === 0
        ? -1
        : (highlightedIndex.value - 1 + suggestions.value.length) % suggestions.value.length;
  } else if (e.key === 'Enter') {
    if (highlightedIndex.value >= 0 && highlightedIndex.value < suggestions.value.length) {
      e.preventDefault();
      selectSuggestion(suggestions.value[highlightedIndex.value]);
    }
  } else if (e.key === 'Escape') {
    closeSuggestions();
  }
}

function onBlur() {
  setTimeout(() => closeSuggestions(), 100)
}

async function toggleInCart( id: number ) {
  shoppingListClient.toggleProductInCartAsync( id ).then( ( response ) => {
    if ( 'error' in response ) {
      console.error( response.error );
    }

    refresh();
  } );
}

async function addToShoppingList( e: SubmitEvent ) {
  if ( addToShoppingListParameters.name.trim() === '' ) {
    errors.name = 'Nazwa powinna być wypełniona';
    return;
  }

  shoppingListClient
    .addToShoppingListAsync(
        route.params.id,
        UnitEnum.valueOf( addToShoppingListParameters.unit.name ),
        addToShoppingListParameters.quantity,
        addToShoppingListParameters.name,
        addToShoppingListParameters.categoryId,
    )
    .then( () => {
      (e.currentTarget as HTMLFormElement)?.reset();
      resetAddToShoppingListParameters();
      refresh();
    } );
}

function resetAddToShoppingListParameters() {
  addToShoppingListParameters.name = '';
  addToShoppingListParameters.quantity = 1;
  errors.name = '';
}
</script>

<template>
  <div class="card flex justify-center flex-col max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li class="px-2 inline-flex flex-row gap-2">
        <NuxtLink to="/">
          <Icon name="streamline-freehand:keyboard-arrow-return" />
        </NuxtLink>
        <Icon v-if="status === 'pending'" class="animate-spin text-info" name="streamline-freehand:loading-star-1" />
      </li>
      <li>
        <form class="grid grid-cols-[80px_minmax(0,_auto)_45px]" @submit.prevent="addToShoppingList">
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
                :aria-activedescendant="highlightedIndex >= 0 ? `suggestion-${highlightedIndex}` : null"
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
                  v-for="(s, idx) in suggestions"
                  v-else-if="suggestions.length > 0"
                  :id="`suggestion-${idx}`"
                  :key="s.id || s.name + idx"
                  role="option"
                  class="inline-flex flex-row justify-between items-center"
                  :class="{
        'active': idx === highlightedIndex
      }"
                  :aria-selected="idx === highlightedIndex"
                  @click="selectSuggestion(s)"
                  @mouseenter="highlightedIndex = idx"
                  @mousedown.prevent
              >
                <span>{{ s.name }}</span>
                <span class="badge badge-ghost badge-sm">{{ s.unit || 'szt.' }}</span>
              </li>

              <li v-else-if="!suggestionsLoading && suggestions.length === 0" class="disabled" role="presentation">
                <span class="opacity-60">Brak sugestii</span>
              </li>
            </ul>
          </div>
          <button class="btn btn-ghost btn-square ">
            <Icon name="streamline-freehand:add-sign-bold" />
          </button>
          <input
              v-model="addToShoppingListParameters.quantity"
              class="input input-ghost"
              min="1"
              required
              type="number"
          />
          <select v-model="addToShoppingListParameters.unit" class="select select-ghost col-span-2">
            <option disabled selected>Wybierz jednostkę</option>
            <option v-for="unit in units" :key="unit.name" :value="unit">{{ unit.name }}</option>
          </select>
        </form>
      </li>
      <li
          v-for="datum in data"
          v-if="data?.length"
          :key="datum.id"
          :class="{ 'line-through': datum.inCart}"
          class="list-row"
          @click="toggleInCart( datum.id )"
      >
        <span class="list-col-grow">{{ datum.name }}</span>
        <span>{{ datum.quantity }} {{ datum.unit }}</span>
      </li>
      <li v-else class="list-row">Brak produktów na liście</li>
    </ul>
    <div v-if="error">{{ error }}</div>
  </div>
</template>

<style scoped>

</style>