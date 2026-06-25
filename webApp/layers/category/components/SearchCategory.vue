<script setup lang="ts">
import type { Category } from '@bill/Bill-shoppingList'

import BaseAutocomplete from '#layers/ui/components/BaseAutocomplete.vue'
import type { BaseAutocompleteProps } from '#layers/ui/types/typesField'
import { normalizeText } from '~/utils/normalizeText'

import CategoryDescriptor from './CategoryDescriptor.vue'

type AutocompleteProps = BaseAutocompleteProps<Category>;

type SearchCategoryProps = /* @vue-ignore */Pick<AutocompleteProps, 'wrapperClass'>

const props = withDefaults(defineProps<SearchCategoryProps>(), {})

const emit = defineEmits<{
  select: [category: Category];
}>();

const { data: categories, status: categoriesStatus } = useGetCategories();

const selectedCategory = ref<Category | null>(null);
const query = ref("");
const categoriesFilterDownByQuery = computed(() => {
  if (!query.value || query.value === selectedCategory.value?.name) {
    return categories.value;
  }

  return categories.value?.filter(({ name }) =>
    normalizeText(name).includes(normalizeText(query.value)),
  );
});

function onSelectCategory(category: Category) {
  selectedCategory.value = category;
  query.value = category.name;
  emit("select", category)
}
</script>

<template>
  <BaseAutocomplete
    v-model="categoryNameQuery"
    :is-loading="categoriesStatus === 'pending'"
    :suggestions="categoriesFilterDownByQuery ?? []"
    label-key="name"
    list-id="categories"
    name="category"
    :wrapperClass="props.wrapperClass"
    @select="onSelectCategory"
  >
    <template #input="{ value: query, listId, handleKeydown, handleClick, handleInput, bindFieldRef, attrs }">
      <div :ref="bindFieldRef" class="flex items-center gap-2 input input-primary w-full">
        <CategoryDescriptor
          :color="selectedCategory?.color"
          :name="selectedCategory?.name ?? query"
        >
          <template #label>
            <input
              :aria-controls="listId"
              :value="query"
              aria-autocomplete="list"
              autocomplete="off"
              placeholder="Kategoria"
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
</template>