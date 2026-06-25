<script setup lang="ts">

import type { DisplayUnit } from "@bill/Bill-shoppingList";
import { useDisplayUnits } from "@product/composables/useDisplayUnits"

import BaseAutocomplete from "#layers/ui/components/BaseAutocomplete.vue"
import type { Query } from "#layers/ui/types/typesField"

const { data: displayUnits } = useDisplayUnits();
const query = defineModel<Query>();
const emit = defineEmits<{
  select: [item: DisplayUnit];
}>();

const unitsFilterDownByQuery = computed(() => {
  if (!displayUnits.value) {
    return [];
  }

  if (!query.value) {
    return toList(displayUnits.value);
  }

  return toList(displayUnits.value.filter(unit => unit.name.toLowerCase().includes(query.value.toLowerCase())));
})

function toList(displayUnits: DisplayUnit[]) {
  return displayUnits.map( ( displayUnit ) => ({ ...displayUnit, id: `${displayUnit.name}=>${displayUnit.baseUnit}` }) )
}

function onSelect(suggestion: DisplayUnit) {
  query.value = suggestion.name
  emit("select", suggestion)
}
</script>

<template>
  <BaseAutocomplete
    name="unit"
    v-model="query"
    :suggestions="unitsFilterDownByQuery ?? []"
    @select="onSelect"
    list-id="units"
    label-key="name"
    placeholder="Nazwa jednostki"
  />
</template>

<style scoped>

</style>