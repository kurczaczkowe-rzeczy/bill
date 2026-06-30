export function useMenuClient() {
  const { $menuClient } = useNuxtApp();
  return $menuClient;
}
