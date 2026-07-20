<script lang="ts" setup>
import BaseButton from '@ui/components/BaseButton.vue'

import type { NavMeta } from '#app'

const { routes } = useNavigation()
const currentRoute = useRoute()

interface NavItem extends Omit<NavMeta, 'name'> {
  to: string;
}

function useNavigation() {
  const router = useRouter()

  const routes = computed( () =>
    router
      .getRoutes()
      .filter( ( route ) => route.meta.nav )
      .reduce( ( routes, route ) => {
        const navMeta = route.meta.nav
        if ( typeof navMeta === 'string' || navMeta === undefined || routes.has( navMeta.name ) ) {
          return routes
        }

        routes.set( navMeta.name, {
          label: navMeta.label,
          to: route.path,
          icon: navMeta.icon,
        } )

        return routes
      }, new Map<string, NavItem>() ),
  )

  return { routes }
}
</script>

<template>
  <slot />
  <dev-only>
    <nav v-if="routes.size > 1" class="fixed bottom-0 pointer-events-none w-full">
      <div class="stack stack-end h-13.5 hover:grid-cols-3 hover:gap-2 transition-all pointer-events-auto">
        <BaseButton
          v-for="[routeName, route] in routes"
          :active="currentRoute.meta.nav === routeName || (typeof currentRoute.meta.nav === 'object' && currentRoute.meta.nav.name === routeName)"
          :to="route.to"
          appearance="soft"
          circle
          class="border border-primary/25 col-span-1 row-start-1"
          color="primary"
          size="lg"
        >
          <Icon :name="route.icon" size="1.5em" />
        </BaseButton>
      </div>
    </nav>
  </dev-only>
</template>

<style scoped>
</style>