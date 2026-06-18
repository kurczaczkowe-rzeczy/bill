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
  <nav v-if="routes.size > 1" class="fixed bottom-2 left-0 right-0 flex justify-center gap-4 p-4 pointer-events-none">
    <BaseButton
      v-for="[routeName, route] in routes"
      :active="currentRoute.meta.nav === routeName || (typeof currentRoute.meta.nav === 'object' && currentRoute.meta.nav.name === routeName)"
      :to="route.to"
      appearance="soft"
      circle
      class="pointer-events-auto"
      color="primary"
      size="lg"
    >
      <Icon :name="route.icon" size="1.5em" />
    </BaseButton>
  </nav>
</template>

<style scoped>
</style>