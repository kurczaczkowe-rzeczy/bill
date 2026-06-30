<script lang="ts" setup>
import type {
  CreateUserMealIngredient,
  DisplayUnit,
  Nullable,
} from '@bill/Bill-shoppingList'
import { useDisplayUnits } from '@product/composables/useDisplayUnits'
import type { ProductSuggestion } from '@product/types'
import BaseButton from '@ui/components/BaseButton.vue'
import BaseCard from '@ui/components/BaseCard.vue'
import FormControl from '@ui/components/FormControl.vue'

import { useMenuClient } from '#layers/menu/composables/useMenuClient'
import SearchProduct from '#layers/product/components/SearchProduct.vue'
import BaseList from '~/components/BaseList.vue'

interface CreateMealIngredient extends CreateUserMealIngredient {
  id: string;
  name: string;
  unit: string;
  rawProduct: ProductSuggestion;
  rawUnit: DisplayUnit;
}

interface CreateMealParams {
  name: string;
  type: string;
  recipeDesc: string;
  recipeLink: string;
  servings: number;
  servingsMultiplier: number;
  ingredients: CreateMealIngredient[];
}

interface Ingredient {
  name: string;
  unit: string;
  quantity: number;
  rawProduct: ProductSuggestion | null;
  rawUnit: DisplayUnit | null;
}

definePageMeta( {
  nav: {
    name: 'meals',
    icon: 'RestaurantMenuIcon',
    label: 'Posiłki',
  },
} )

const { data = [], refresh, pending: isLoading } = useGetMeals( {  } )

const menuClient = useMenuClient()
const { data: displayUnits } = useDisplayUnits()

const mealData = reactive<CreateMealParams>( {
  name: '',
  type: '',
  recipeDesc: '',
  recipeLink: '',
  servings: 0,
  servingsMultiplier: 0,
  ingredients: []
} )

const ingredient = reactive<Ingredient>( {
  name: '',
  unit: '',
  quantity: 0,
  rawProduct: null,
  rawUnit: null,
} )

const isDisabledAddIngredient = computed( () => !ingredient.name || !ingredient.unit || !ingredient.quantity)

const ingredientNameSuggestion = useTemplateRef<Nullable<HTMLInputElement>>('ingredient-name-suggestion')

function selectIngredientSuggestion( suggestion: ProductSuggestion ) {
  ingredient.name = suggestion.name
  ingredient.unit = displayUnits.value?.find(
    ( { baseUnit, multiplier } ) => baseUnit === suggestion.baseUnit.baseUnit && multiplier === 1,
  )?.name ?? suggestion.baseUnit.name
  ingredient.rawProduct = suggestion
  ingredient.rawUnit = suggestion.baseUnit
}

function selectIngredientUnit( suggestion: DisplayUnit ) {
  ingredient.unit = displayUnits.value?.find(
    ( { baseUnit, multiplier } ) => baseUnit === suggestion.baseUnit && multiplier === 1,
  )?.name ?? suggestion.name
  ingredient.rawUnit = suggestion
}

// ToDo: switch to uuid
let id = 0

function onAddIngredient() {
  if ( !ingredient.rawProduct || !ingredient.rawUnit ) {
    return
  }

  mealData.ingredients.push( {
    id: (
      id++
    ).toString(),
    name: ingredient.name,
    unit: ingredient.unit,
    productId: ingredient.rawProduct.id,
    quantity: ingredient.quantity,
    rawProduct: ingredient.rawProduct,
    rawUnit: ingredient.rawUnit,
  } as CreateMealIngredient )

  ingredient.name = ''
  ingredient.unit = ''
  ingredient.quantity = 0
  ingredient.rawProduct = null
  ingredient.rawUnit = null

  ingredientNameSuggestion.value?.focus()
}

function onDeleteIngredient( id: string ) {
  mealData.ingredients = mealData.ingredients.filter( ( ingredient ) => ingredient.id !== id )
}

async function onCreateMeal() {
  try {
    await menuClient.createMealWithIngredientsAsync( {
      name: mealData.name,
      type: mealData.type,
      recipeDesc: mealData.recipeDesc,
      recipeLink: mealData.recipeLink,
      servings: mealData.servings,
      servingsMultiplier: mealData.servingsMultiplier,
      // @ts-expect-error ts not understand this
      ingredients: mealData.ingredients.map( ( ingredient ) => ({
        productId: ingredient.productId,
        quantity: ingredient.quantity * ingredient.rawUnit.multiplier,
      }) ),
    })
    refresh()
  } catch (e) {
    console.error(e)
  }
}

function onRefresh() {
  refresh()
}
</script>

<template>
  <div class="w-full flex gap-4 justify-center max-h-full flex-wrap">
    <BaseCard class="justify-center basis-xl [&_.card-body]:gap-4">
      <form class="grid grid-cols-[repeat(12),_minmax(0,_45px)] gap-4 w-full">
        <FormControl
          v-model="mealData.name"
          class="col-span-8"
          label="Nazwa"
          name="name"
          placeholder="Nazwa"
          type="text"
        />
        <FormControl v-model="mealData.type" class="col-span-4" label="Typ" name="type" placeholder="Typ" type="text" />
        <FormControl
          v-model="mealData.recipeDesc"
          class="col-span-12"
          label="Opis przygotowania"
          name="recipeDesc"
          placeholder="Opis przygotowania"
          type="textarea"
        />
        <FormControl
          v-model="mealData.recipeLink"
          class="col-span-8"
          label="Link do przepisu"
          name="recipeLink"
          placeholder="Link do przepisu"
          type="text"
        />
        <FormControl v-model="mealData.servings" label="Porcji" name="servings" placeholder="Porcji" type="number" class="col-span-2" />
        <FormControl
          v-model="mealData.servingsMultiplier"
          label="Mnożnik"
          name="servingsMultiplier"
          placeholder="Mnożnik porcji"
          type="number"
          class="col-span-2"
        />
        <FormControl class="col-span-6" label="Nazwa produktu">
          <SearchProduct
            ref="ingredient-name-suggestion"
            v-model="ingredient.name"
            @select="selectIngredientSuggestion"
          />
        </FormControl>
        <FormControl
          v-model="ingredient.quantity"
          label="Ilość"
          name="ingredientQuantity"
          placeholder="Ilość"
          type="number"
          class="col-span-2"
          :min="0"
        />
        <FormControl class="col-span-3" label="Nazwa jednostki">
          <SearchUnit
            v-model="ingredient.unit"
            @select="selectIngredientUnit"
          />
        </FormControl>
        <BaseButton circle class="self-end-safe col-span-1" @click="onAddIngredient" :disabled="isDisabledAddIngredient">
          <Icon name="streamline-freehand:add-sign-bold" />
        </BaseButton>
      </form>
      <figure class="flex-col">
        <figcaption class="divider divider-primary">Składniki:</figcaption>
        <BaseList class="w-full" :items="mealData.ingredients" :itemProps="() => ({ class: 'items-center' })">
          <template #item="{ item: ingredient }">
            <span class="list-col-grow">{{ ingredient.name }} </span>
            <span>{{ ingredient.quantity }} {{ ingredient.unit }}</span>
            <BaseButton circle @click.stop="onDeleteIngredient(ingredient.id)" size="sm">
              <Icon name="streamline-freehand:remove-delete-sign-bold" />
            </BaseButton>
          </template>
          <template #empty>
            Brak składników
          </template>
        </BaseList>
      </figure>
      <BaseButton appearance="solid" @click="onCreateMeal">Dodaj przepis</BaseButton>
    </BaseCard>
    <BaseCard class="justify-center basis-xl">
      <BaseButton @click="onRefresh" :disabled="isLoading"><span>Załaduj ponownie</span>
      <Icon
        v-show="isLoading"
        class="animate-spin text-info"
        name="streamline-freehand:loading-star-1"
      /></BaseButton>
      <BaseList
        :item-props="() => ({ class: 'items-center' })"
        :items="data"
      >
        <template #item="{ item: meal }">
          <NuxtLink :to="{ name: 'meals-id', params: { id: meal.id } }">
            <span>{{ meal.name }}</span>
          </NuxtLink>
        </template>
        <template #empty>Brak posiłków</template>
      </BaseList>
    </BaseCard>
  </div>
</template>

<style scoped>

</style>