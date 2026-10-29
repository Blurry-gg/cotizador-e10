// Modelo del cotizador en TypeScript. El mismo cálculo que el motor de Elixir, pero aquí
// los estados que no existen (una peligrosa sin número UN, un despachado sin folio...)
// ni siquiera compilan.

export type Puente = 'comercio_mundial' | 'colombia';

// La carga, discriminada por tipo: cada tipo trae exactamente los datos que necesita.
export type Carga =
  | { readonly tipo: 'general' }
  | { readonly tipo: 'refrigerada' }
  | { readonly tipo: 'peligrosa'; readonly numeroUn: string }
  | { readonly tipo: 'sobredimensionada'; readonly permiso: string };

// Lo que tiene todo embarque, sin importar la carga.
export interface DatosEmbarque {
  readonly id: string;
  readonly pesoKg: number;
  readonly distanciaKm: number;
  readonly puente: Puente;
}

// Datos comunes Y una carga: si el tipo es 'peligrosa', exige numeroUn.
export type Embarque = DatosEmbarque & Carga;

export interface Cotizacion {
  readonly id: string;
  readonly fleteBruto: number;
  readonly descuento: number;
  readonly flete: number;
  readonly cuotaPuente: number;
  readonly recargo: number;
  readonly ajusteMinimo: number;
  readonly total: number;
}

// Solo tres: los otros cuatro motivos del motor (tipo o puente desconocido, peligrosa sin UN,
// sobredimensionada sin permiso) ya no se pueden escribir.
export type Motivo = 'peso_invalido' | 'distancia_invalida' | 'excede_peso_maximo';

export interface Reglas {
  readonly tarifaKm: number;
  readonly cuotaPuente: Readonly<Record<Puente, number>>;
  readonly descuento: {
    readonly umbralKg: number;
    readonly pct: number;
    readonly criterio: 'a_partir_de' | 'mas_de';
  };
  readonly recargo: Readonly<Record<Carga['tipo'], { readonly pct: number; readonly fija: number }>>;
  readonly baseRecargo: 'flete' | 'subtotal';
  readonly minimo: number;
  readonly pesoMaximoKg: number;
}

// Los cuatro estados, discriminados por estado. Cada uno trae solo lo que tiene sentido.
export interface Borrador {
  readonly estado: 'borrador';
  readonly embarque: Embarque;
}

export interface Cotizado {
  readonly estado: 'cotizado';
  readonly embarque: Embarque;
  readonly cotizacion: Cotizacion;
}

export interface Rechazado {
  readonly estado: 'rechazado';
  readonly embarque: Embarque;
  readonly motivo: Motivo;
}

export interface Despachado {
  readonly estado: 'despachado';
  readonly embarque: Embarque;
  readonly cotizacion: Cotizacion;
  readonly folio: string;
}

export type Estado = Borrador | Cotizado | Rechazado | Despachado;

// El {:ok, valor} | {:error, motivo} de Elixir: hay que preguntar r.ok antes de leer r.valor.
export type Resultado<T, E> = { readonly ok: true; readonly valor: T } | { readonly ok: false; readonly error: E };

// Etapa 2.
export function cotizar(_b: Borrador, _r: Reglas): Cotizado | Rechazado {
  throw new Error('por implementar');
}

// Etapa 3. Por la firma, solo un Cotizado se puede despachar.
export function despachar(_c: Cotizado, _folio: string): Despachado {
  throw new Error('por implementar');
}
