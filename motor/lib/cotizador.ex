defmodule Cotizador do
  def cotizar(%{peso_kg: p}, _reglas) when p <= 0, do: {:error, :peso_invalido}
end
