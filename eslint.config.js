// Configuración base del curso. NO incluye todavía las reglas de inmutabilidad:
// esas se encienden hasta la semana 15, cuando ya vivieron la restricción en Elixir.
import js from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      'eqeqeq': ['error', 'always'],           // nada de == : la coerción esconde defectos
      'no-param-reassign': 'error',            // no reasignar parámetros
      'prefer-const': 'error',                 // si no cambia, que no sea let
      'no-var': 'error',
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'error'
    }
  },
  { ignores: ['node_modules', 'dist'] }
);
