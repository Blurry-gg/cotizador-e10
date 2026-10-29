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

// Lo que cambia por tipo de carga vive en esta tabla, no en un if sobre el tipo (taller 4).
// Record obliga a que esté cada tipo: si se agrega uno a Carga, esto no compila hasta llenarlo.
interface Politica {
  readonly respetaPesoMaximo: boolean;
}

const POLITICAS: Readonly<Record<Carga['tipo'], Politica>> = {
  general: { respetaPesoMaximo: true },
  refrigerada: { respetaPesoMaximo: true },
  peligrosa: { respetaPesoMaximo: true },
  // Viaja con permiso especial: puede pasar del peso máximo.
  sobredimensionada: { respetaPesoMaximo: false },
};

// Un porcentaje, redondeado al centavo, las mitades hacia arriba. Es el div(monto * p + 50, 100)
// del motor: con montos positivos, Math.floor da lo mismo.
const pct = (monto: number, p: number): number => Math.floor((monto * p + 50) / 100);

const ok = <T>(valor: T): Resultado<T, never> => ({ ok: true, valor });
const error = <E>(e: E): Resultado<never, E> => ({ ok: false, error: e });

// Los tres motivos, en el orden del enunciado: el primero que aplica, gana.
function validar(e: Embarque, r: Reglas): Resultado<Embarque, Motivo> {
  if (e.pesoKg <= 0) return error('peso_invalido');
  if (e.distanciaKm <= 0) return error('distancia_invalida');
  if (POLITICAS[e.tipo].respetaPesoMaximo && e.pesoKg > r.pesoMaximoKg) return error('excede_peso_maximo');
  return ok(e);
}

// El criterio es un dato de las reglas, no un tipo de carga: aquí sí va un ternario.
function descuento(pesoKg: number, fleteBruto: number, d: Reglas['descuento']): number {
  const aplica = d.criterio === 'a_partir_de' ? pesoKg >= d.umbralKg : pesoKg > d.umbralKg;
  return aplica ? pct(fleteBruto, d.pct) : 0;
}

function calcular(e: Embarque, r: Reglas): Cotizacion {
  const fleteBruto = r.tarifaKm * e.distanciaKm;
  const desc = descuento(e.pesoKg, fleteBruto, r.descuento);
  const flete = fleteBruto - desc;
  const cuotaPuente = r.cuotaPuente[e.puente];
  const { pct: p, fija } = r.recargo[e.tipo];
  const base = r.baseRecargo === 'flete' ? flete : flete + cuotaPuente;
  const recargo = pct(base, p) + fija;
  const sinMinimo = flete + cuotaPuente + recargo;
  const total = Math.max(sinMinimo, r.minimo);

  return {
    id: e.id,
    fleteBruto,
    descuento: desc,
    flete,
    cuotaPuente,
    recargo,
    ajusteMinimo: total - sinMinimo,
    total,
  };
}

// Validar y, solo si pasa, calcular: el with del motor.
export function cotizar(b: Borrador, r: Reglas): Cotizado | Rechazado {
  const v = validar(b.embarque, r);
  if (!v.ok) return { estado: 'rechazado', embarque: b.embarque, motivo: v.error };
  return { estado: 'cotizado', embarque: v.valor, cotizacion: calcular(v.valor, r) };
}

// Etapa 3. Por la firma, solo un Cotizado se puede despachar.
export function despachar(_c: Cotizado, _folio: string): Despachado {
  throw new Error('por implementar');
}
