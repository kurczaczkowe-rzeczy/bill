<script lang="ts" setup>
import { ShoppingListClient, type ShoppingListDetails, UnitEnum } from '@bill/Bill-shoppingList';

import type { KtList } from '~/utils/ktListToArray';
import { ktToJs } from '~/utils/ktToJs';

const route = useRoute();

const shoppingListClient = new ShoppingListClient();

const { data, error, refresh } = await useAsyncData( 'shoppingListDetails', async () => {
  const response = await shoppingListClient.getShoppingListAsync( route.params.id );

  if ( 'error' in response ) {
    throw new Error( response as any );
  }

  if ( !(
      'result' in response
  ) ) {
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

const units = UnitEnum.values();

function resetAddToShoppingListParameters() {
  addToShoppingListParameters.name = '';
  addToShoppingListParameters.quantity = 1;
  errors.name = '';
}
</script>

<template>
  <div class="card flex justify-center flex-col max-w-xl m-auto">
    <ul class="card-body list bg-base-100 rounded-box shadow-md w-full">
      <li class="px-2">
        <NuxtLink to="/">
          <Icon name="streamline-freehand:keyboard-arrow-return" />
        </NuxtLink>
      </li>
      <li>
        <form class="grid grid-cols-[80px_minmax(0,_auto)_45px]" @submit.prevent="addToShoppingList">
          <input
              v-model="addToShoppingListParameters.name"
              class="input input-ghost col-span-2"
              placeholder="Nazwa produktu"
              required
              type="text"
          />
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