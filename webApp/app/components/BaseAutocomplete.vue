<script generic="Suggestion extends Item" lang="ts" setup>
import { autoUpdate, flip, offset, shift, size, useFloating } from "@floating-ui/vue";
import { onClickOutside, useDebounceFn } from "@vueuse/core";

import type { Item } from "~/types/item";

type Query = string;
type Properties = keyof Suggestion;
type Suggestions = Suggestion[];

interface Props {
  modelValue?: Query;
  suggestions: Suggestions;
  isLoading?: boolean;
  placeholder?: string;
  wrapperClass?: string;
  debounceMs?: number;
  labelKey?: string;
  minLengthQuery?: number;
  listId: string;
  matchBy?: (suggestion: Suggestion, query: Query) => boolean;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: "",
  wrapperClass: "",
  suggestions: () => [],
  isLoading: false,
  placeholder: "Wyszukaj...",
  labelKey: "label",
  debounceMs: 300,
  minLengthQuery: 3,
});

const emit = defineEmits<{
  "update:modelValue": [value: Query];
  search: [query: Query];
  select: [item: Suggestion];
}>();

const query = ref<Query>(props.modelValue);
const isOpen = ref(false);
const highlightedIndex = ref(-1);
const containerRef = ref<HTMLElement>();

const reference = ref();
const floating = ref();

const { floatingStyles } = useFloating(reference, floating, {
  placement: "bottom-start",
  middleware: [
    offset(10),
    flip(),
    shift(),
    size({
      apply({ availableWidth, elements }) {
        Object.assign(elements.floating.style, {
          maxWidth: `${availableWidth}px`,
          width: `${elements.reference.getBoundingClientRect().width}px`,
        });
      },
    }),
  ],
  whileElementsMounted: autoUpdate,
});

const debouncedSearch = useDebounceFn((value: string) => {
  emit("search", value);
}, props.debounceMs);

function handleInput(event: Event) {
  isOpen.value = true;

  const value = (event.target as HTMLInputElement).value;
  query.value = value;
  emit("update:modelValue", value);
  highlightedIndex.value = -1;

  if (value.length >= props.minLengthQuery) {
    debouncedSearch(value);
  }
}

function handleKeydown(event: KeyboardEvent) {
  switch (event.key.toLowerCase()) {
    case "arrowdown": {
      event.preventDefault();
      highlightedIndex.value = Math.min(highlightedIndex.value + 1, props.suggestions.length - 1);
      if (!isOpen.value && highlightedIndex.value >= 0) {
        selectItem(props.suggestions[highlightedIndex.value]);
      }
      break;
    }

    case "arrowup": {
      event.preventDefault();
      highlightedIndex.value = Math.max(highlightedIndex.value - 1, 0);
      if (!isOpen.value && highlightedIndex.value >= 0) {
        selectItem(props.suggestions[highlightedIndex.value]);
      }
      break;
    }

    case "enter": {
      if (isOpen.value) {
        event.preventDefault();
        if (highlightedIndex.value >= 0) {
          selectItem(props.suggestions[highlightedIndex.value]);
        }
      }
      break;
    }

    case "escape": {
      isOpen.value = false;
      highlightedIndex.value = -1;
      break;
    }

    case "tab": {
      if (isOpen.value) {
        event.preventDefault();
        selectItem(props.suggestions[highlightedIndex.value]);
      }
      isOpen.value = false;

      // This is for cases when the suggestion list is changing by computable for ex. value bound to modelValue
      // is used in computable to filter a static list. It protects against switching to other suggestions
      highlightedIndex.value = getSuggestionIndexBaseOn(props.suggestions, query.value);
      if (highlightedIndex.value >= 0) {
        selectItem(props.suggestions[highlightedIndex.value]);
      }
      break;
    }
  }
}

function selectItem(item?: Suggestion) {
  if (!item) {
    return;
  }
  emit("select", item);

  query.value = `${item[props.labelKey as Properties]}` || item.toString();
  emit("update:modelValue", query.value);

  if (isOpen.value) {
    highlightedIndex.value = props.suggestions.findIndex((suggestion) => suggestion.id === item.id);
  }
  isOpen.value = false;
}

function handleClick() {
  if (props.suggestions.length === 0) {
    return;
  }

  highlightedIndex.value = getSuggestionIndexBaseOn(props.suggestions, query.value);
  isOpen.value = true;
}

onClickOutside(containerRef, () => {
  isOpen.value = false;
});

function bindFieldRef(el: HTMLElement) {
  reference.value = el;
}

function getSuggestionIndexBaseOn(suggestions: Suggestions, query: Query): number {
  return suggestions.findIndex((suggestion) => {
    if (props.matchBy) {
      return props.matchBy?.(suggestion, query);
    }

    return suggestion[props.labelKey as Properties] === query;
  });
}

watch(
  () => props.modelValue,
  (newValue) => {
    query.value = newValue;
  },
);
</script>

<template>
  <div ref="containerRef" :class="wrapperClass" class="relative w-full">
    <slot
      :attrs="$attrs"
      :bind-field-ref="bindFieldRef"
      :handle-click="handleClick"
      :handle-input="handleInput"
      :handle-keydown="handleKeydown"
      :list-id="listId"
      :value="query"
      name="input"
    >
      <div ref="reference" class="flex items-center gap-2 input input-ghost w-full">
        <input
          v-model="query"
          :aria-controls="listId"
          :placeholder="placeholder"
          aria-autocomplete="list"
          autocomplete="off"
          role="combobox"
          type="text"
          v-bind="$attrs"
          @click="handleClick"
          @input="handleInput"
          @keydown="handleKeydown"
        />
        <Icon class="autocomplete-arrow" name="mdi:chevron-down" />
      </div>
    </slot>

    <Teleport to="#teleports">
      <div
        v-if="isOpen"
        ref="floating"
        :style="floatingStyles"
        class="absolute z-50 w-full bg-base-100 rounded-box shadow-lg border-1 overflow-hidden"
      >
        <ul
          :id="listId"
          class="list max-h-64 overflow-auto"
        >
          <!-- Slot: Loading -->
          <li v-if="isLoading" class="list-row">
            <slot name="loading">
              <span class="loading loading-spinner loading-sm"></span>
              Ładowanie…
            </slot>
          </li>

          <!-- Slot: Empty state -->
          <li v-else-if="!isLoading && suggestions.length === 0 && query" class="list-row">
            <slot :query="query" name="no-results">
              <span class="opacity-60">Brak wyników dla "{{ query }}"</span>
            </slot>
          </li>

          <li
            v-for="(item, index) in suggestions"
            v-else
            :key="item.id || index"
            :class="[
          'list-row cursor-pointer transition-colors',
          highlightedIndex === index ? 'bg-base-200' : 'hover:bg-base-200'
        ]"
            @click="selectItem(item)"
            @mouseenter="highlightedIndex = index"
          >
            <slot :highlighted="highlightedIndex === index" :index="index" :item="item" name="item">
              {{ item[ labelKey as Properties ] }}
            </slot>
          </li>
        </ul>
      </div>
    </Teleport>
  </div>
</template>

<style>
.autocomplete-arrow {
  margin-right: 0.2rem;
}
</style>