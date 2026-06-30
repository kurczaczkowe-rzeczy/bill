<script setup lang="ts">
import type { Ingredient } from '@bill/Bill-shoppingList'
import BaseButton from '@ui/components/BaseButton.vue'
import BaseCard from '@ui/components/BaseCard.vue'

import BaseList from '~/components/BaseList.vue'

definePageMeta({
  nav: "meals",
});
const route = useRoute();

const { data , refresh, pending: isLoading } = useGetMeal( route.params.id )

const { mapUnitToDisplayUnit } = useDisplayUnits()

function printUnitWithQuantity( ingredient: Ingredient ) {
  const { baseUnit, quantity } = mapUnitToDisplayUnit(ingredient.baseUnit, ingredient.quantity)

  return `${quantity}${baseUnit}`
}
</script>

<template>
  <div class="w-full flex gap-4 justify-center max-h-full flex-wrap">

  <BaseCard class="justify-center basis-xl [&_.card-body]:gap-4">
    <BaseButton circle to="/meals">
      <Icon name="streamline-freehand:keyboard-arrow-return" />
    </BaseButton>
    <p class="flex flex-col gap-2">
      <span><b>Nazwa:</b> {{ data?.name }}</span>
      <span><b>Typ:</b> {{ data?.type }} </span>
      <span><b>Opis:</b> {{ data?.recipeDesc }}</span>
      <span><b>Źródło:</b> {{ data?.recipeLink }}</span>
      <span v-if="data"><b>{{ data.servings * data.servingsMultiplier }} porcji</b></span>
    </p>

    <figure class="flex-col">
      <figcaption class="divider divider-primary">Składniki:</figcaption>
      <BaseList class="w-full" :items="data?.ingredients ?? []" :itemProps="() => ({ class: 'items-center' })">
        <template #item="{ item: ingredient }">
          <span class="list-col-grow">{{ ingredient.name }} </span>
          <span>{{ printUnitWithQuantity(ingredient) }}</span>
        </template>
      </BaseList>
    </figure>
  </BaseCard>
  </div>
</template>

<style scoped>

</style>