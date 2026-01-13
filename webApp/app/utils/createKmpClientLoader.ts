interface KmpClientConfig {
  supabaseUrl: string;
  supabaseKey: string;
}

type ClientLoader<T> = (config?: KmpClientConfig) => Promise<T>;

export function createKmpClientLoader<TModule, T = unknown>(
  importFn: () => Promise<TModule>,
  factoryFn: (module: TModule, config?: KmpClientConfig) => T,
): ClientLoader<T> {
  let instance: T | null = null;
  let loading: Promise<T> | null = null;

  return async (config?: KmpClientConfig): Promise<T> => {
    if (instance) return instance;
    if (loading) return loading;

    loading = (async () => {
      const module = await importFn();
      instance = factoryFn(module, config);
      return instance;
    })();

    return loading;
  };
}
