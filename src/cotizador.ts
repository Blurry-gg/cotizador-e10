export const TARIFA_BASE = 12.5;

/**
 * Calcula el cargo de un embarque.
 *
 * Regla de negocio: hay descuento por volumen del 8 % A PARTIR DE 1000 kg.
 * "A partir de" incluye el 1000.
 */
export function cargo(kg: number): number {
  const bruto = kg * TARIFA_BASE;
  // TODO: esta línea tiene un defecto. La prueba de tests/cotizador.test.ts lo detecta.
  return kg >= 1000 ? bruto * 0.92 : bruto;
}
