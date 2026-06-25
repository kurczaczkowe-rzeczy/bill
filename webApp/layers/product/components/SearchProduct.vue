<script setup lang="ts">
import { DisplayUnit, type Product } from "@bill/Bill-shoppingList"
import { useDisplayUnits } from "@product/composables/useDisplayUnits";
import { useProductClient } from "@product/composables/useProductClient";
import type { ProductSuggestion } from "@product/types"

import BaseAutocomplete from "#layers/ui/components/BaseAutocomplete.vue"
import BaseMatchEmphasis from "#layers/ui/components/BaseMatchEmphasis.vue"
import type { BaseAutocompleteProps } from "#layers/ui/types/typesField"
import type { KtList } from "~/utils/ktListToArray"
import { ktToJs } from "~/utils/ktToJs"

type AutocompleteProps = BaseAutocompleteProps<ProductSuggestion>;

type SearchProductProps = /* @vue-ignore */Pick<AutocompleteProps, "matchBy" | "wrapperClass">

type Query = AutocompleteProps["modelValue"];

const props = withDefaults(defineProps<SearchProductProps>(), {
});
const emit = defineEmits<{
  select: [item: ProductSuggestion];
}>();

const productClient = useProductClient();
const { data: displayUnits } = useDisplayUnits();

const query = defineModel<Query>();
const suggestions = ref<ProductSuggestion[]>([]);
const suggestionsOpen = ref(false);
const suggestionsLoading = ref(false);
const highlightedIndex = ref(-1);

async function fetchSuggestions(query: string) {
  if (!query || query.trim().length <= 0) {
    suggestions.value = [];
    closeSuggestions();
    return;
  }
  suggestionsLoading.value = true;
  try {
    const response = await productClient.getProductSuggestionAsync(query);

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
          ({ baseUnit, multiplier }) => baseUnit === suggestion.baseUnit && multiplier === 1,
        ) ?? new DisplayUnit(suggestion.baseUnit, suggestion.baseUnit, suggestion.baseUnit, 1);

      return {
        ...suggestion,
        baseUnit: unit,
      } as ProductSuggestion;
    });

    suggestions.value = mappedSuggestions || [];

    openSuggestions();
  } finally {
    suggestionsLoading.value = false;
  }
}

function openSuggestions() {
  if (suggestions.value.length > 0) {
    suggestionsOpen.value = true;
  }
}

function closeSuggestions() {
  suggestionsOpen.value = false;
  highlightedIndex.value = -1;
}

function onSelect(item: ProductSuggestion) {
  emit("select", item);
  closeSuggestions();
}
</script>

<template>
  <BaseAutocomplete
    v-model="query"
    :is-loading="suggestionsLoading"
    :match-by="props.matchBy"
    :suggestions="suggestions"
    label-key="name"
    list-id="suggestions"
    name="product"
    placeholder="Nazwa produktu"
    :wrapperClass="props.wrapperClass"
    @search="fetchSuggestions"
    @select="onSelect"
  >
    <template #item="{ item: suggestion }">
      <span class="list-col-grow">
        <BaseMatchEmphasis
          :text="suggestion.name"
          :query="query"
        />
      </span>
      <span class="badge badge-ghost badge-sm">{{ suggestion.baseUnit.shortName || "szt." }}</span>
    </template>
  </BaseAutocomplete>
</template>

<style scoped>

</style>