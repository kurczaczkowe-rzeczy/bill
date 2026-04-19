export function useProductClient() {
  const { $productClient } = useNuxtApp();
  return $productClient;
}
