defmodule Cotizador do
  @moduledoc """
  Motor de cálculo del cotizador de cruce fronterizo de carga.

  Es puro: recibe el embarque y las reglas como datos y regresa un resultado.
  Ningún número de la variante vive aquí; todo sale de `reglas`.
  """

  @tipos [:general, :refrigerada, :peligrosa, :sobredimensionada]

  @doc """
  Cotiza un embarque con las reglas dadas.

  Regresa `{:ok, cotizacion}` o `{:error, motivo}` con el primer motivo de rechazo.
  """
  def cotizar(embarque, reglas) do
    with :ok <- validar(embarque, reglas) do
      {:ok, calcular(embarque, reglas)}
    end
  end

  # Una cláusula por motivo, en el orden del enunciado: la primera que encaja, gana.
  defp validar(%{peso_kg: p}, _reglas) when p <= 0, do: {:error, :peso_invalido}
  defp validar(%{distancia_km: d}, _reglas) when d <= 0, do: {:error, :distancia_invalida}
  defp validar(%{tipo: t}, _reglas) when t not in @tipos, do: {:error, :tipo_desconocido}

  defp validar(%{puente: p}, %{cuota_puente: cuotas}) when not is_map_key(cuotas, p) do
    {:error, :puente_desconocido}
  end

  defp validar(%{tipo: :peligrosa, numero_un: nil}, _reglas), do: {:error, :falta_numero_un}
  defp validar(%{tipo: :sobredimensionada, permiso: nil}, _reglas), do: {:error, :falta_permiso}

  # La sobredimensionada no tiene peso máximo: si llegó aquí ya trae permiso y está bien.
  # Tiene que ir antes de la del peso máximo, o también la rechazaría.
  defp validar(%{tipo: :sobredimensionada}, _reglas), do: :ok

  defp validar(%{peso_kg: p}, %{peso_maximo_kg: max}) when p > max do
    {:error, :excede_peso_maximo}
  end

  defp validar(_embarque, _reglas), do: :ok

  # Etapa 2 (viernes 16): flete bruto, descuento, flete y cuota del puente.
  defp calcular(_embarque, _reglas), do: %{}
end
