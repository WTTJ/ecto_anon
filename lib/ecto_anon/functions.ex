defmodule EctoAnon.Functions do
  @moduledoc """
  This module is in charge of the function attribution.
  """

  @callback run(atom(), any(), keyword()) :: any()

  @doc """
  Returns the anonymization function based on passed argument
  """
  def get_function(atom) when is_atom(atom) do
    mod = get_module(atom)

    &mod.run/3
  end

  @doc """
  Returns the anonymization module based on passed argument
  """
  def get_module(atom) when is_atom(atom) do
    Module.safe_concat(__MODULE__, constantize(atom))
  end

  defp constantize(atom) when is_atom(atom), do: atom |> Atom.to_string() |> Macro.camelize()
end
