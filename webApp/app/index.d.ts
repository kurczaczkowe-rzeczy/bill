declare module "#app" {
  interface PageMeta {
    nav?: NavMeta | string;
  }

  export interface NavMeta {
    name: string;
    icon: string;
    label: string;
  }
}

export {};
