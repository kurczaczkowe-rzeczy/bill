<script setup lang="ts">
import type { Category, CategoryWithProducts, ShoppingListDetails } from "@bill/Bill-shoppingList";
import type { DraggableEvent } from "vue-draggable-plus";

import BaseCollapse from "~/components/BaseCollapse.vue";
import CategoryDescriptor from "~/components/CategoryDescriptor.vue";
import DraggableList from "~/components/DraggableList.vue";
import { isNil } from "~/utils/isNil";

interface Props {
  categories: Category[];
  categoryWithProducts: CategoryWithProducts;
  onDeleteProduct: (productId: bigint) => void;
  onToggleInCart: (productId: bigint) => void;
  switchProductCategory: (id: bigint, category: Category) => Promise<void>;
}

const props = defineProps<Props>();

const allProductsInCart = computed(() =>
  props.categoryWithProducts.products.every((product) => product.inCart),
);

const isCollapseOpen = ref(
  !(allProductsInCart.value && props.categoryWithProducts.products.length > 0),
);

watch(allProductsInCart, (allInCart) => {
  if (allInCart && props.categoryWithProducts.products.length > 0) {
    isCollapseOpen.value = false;
  }
});

const ITEM_CHOOSE_TIMESTAMP_TIMEOUT = 150;
const itemChooseTimeStamp = ref<number | null>(null);

const draggableOptions = {
  group: "shopping-list",
  animation: 200,
  handle: ".handle",
  onEnd: (evt: DraggableEvent<ShoppingListDetails>) => {
    if (isNil(evt.data)) {
      return;
    }

    const category = props.categories.find(
      (c) => c.id === BigInt(evt.to.parentElement?.dataset.categoryId ?? -1),
    );

    if (!category) {
      return;
    }

    props.switchProductCategory(evt.data.id, category);
    // Timestamp is set to prevent calling whole click event when user chooses an element to reorder.
    // So I need to reset it here to make it possible to call click event.
    setTimeout(() => {
      itemChooseTimeStamp.value = null;
    }, ITEM_CHOOSE_TIMESTAMP_TIMEOUT);
  },
  forceFallback: true,
  fallbackClass: "hidden",
  onChoose: (_evt: DraggableEvent<ShoppingListDetails>) => {
    itemChooseTimeStamp.value = Date.now();
  },
};

function handleToggleInCart(productId: bigint) {
  if (
    itemChooseTimeStamp.value &&
    Date.now() - itemChooseTimeStamp.value > ITEM_CHOOSE_TIMESTAMP_TIMEOUT
  ) {
    return;
  }

  props.onToggleInCart(productId);
}
</script>

<template>
  <BaseCollapse v-model:open="isCollapseOpen" class="shrink-0">
    <template #summary>
      <CategoryDescriptor :name="categoryWithProducts.category.name" :color="categoryWithProducts.category.color" />
    </template>
    <template #content>
      <DraggableList
        :="draggableOptions"
        :data-category-id="categoryWithProducts.category.id"
        :itemProps="(product) => ({
          class: [{ 'line-through': product.inCart }, 'items-center'],
          onClick: () => handleToggleInCart( product.id )
        })"
        :items="categoryWithProducts.products as unknown as ShoppingListDetails[]"
      >
        <template #item="{ item: product }">
          <button
            class="btn btn-ghost btn-sm handle relative -my-3"
            @click.stop
          >
            <Icon name="streamline-freehand:data-transfer-vertical" />
          </button>
          <span class="list-col-grow -ml-10">{{ product.name }} </span>
          <span>{{ product.quantity }} {{ product.unit }}</span>
          <button
            class="btn btn-ghost btn-sm -m-4"
            @click.stop="onDeleteProduct(product.id)">
            <Icon name="streamline-freehand:remove-delete-sign-bold" />
          </button>
        </template>
        <template #empty>Brak produktów w kategorii</template>
      </DraggableList>
    </template>
  </BaseCollapse>
</template>

<style scoped>
.handle {
  left: calc(var(--card-p, 1.5rem) * -1);
}
</style>