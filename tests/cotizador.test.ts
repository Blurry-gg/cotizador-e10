import { describe, it, expect } from 'vitest';
import { cargo } from '../src/cotizador.js';

describe('cargo', () => {
  it('cobra tarifa base cuando no hay descuento', () => {
    expect(cargo(100)).toBe(1250);
  });

  it('aplica descuento por volumen por encima de 1000 kg', () => {
    expect(cargo(2000)).toBe(23000);
  });

  // Esta prueba arranca en ROJO. "A partir de 1000" incluye a 1000; el código dice > 1000.
  it('aplica descuento EXACTAMENTE en 1000 kg', () => {
    expect(cargo(1000)).toBe(11500);
  });
});
