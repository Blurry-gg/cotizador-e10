export type Puente = 'comercio_mundial' | 'colombia';
export type Borrador = unknown;
export type Cotizado = unknown;
export type Rechazado = unknown;
export type Despachado = unknown;
export type Reglas = unknown;

export function cotizar(_b: Borrador, _r: Reglas): Cotizado | Rechazado {
  throw new Error('por implementar');
}

export function despachar(_c: Cotizado, _folio: string): Despachado {
  throw new Error('por implementar');
}
