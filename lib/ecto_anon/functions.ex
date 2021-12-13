defmodule EctoAnon.Functions do
  @moduledoc """
  This module is in charge of the function attribution.
  """

  def get_function(atom) when is_atom(atom) do
    mod = get_module(atom)

    &mod.run/1
  end

  @doc """
  Returns the right anonymizing module.
  """
  def get_module(atom) when is_atom(atom) do
    Module.safe_concat(__MODULE__, constantize(atom))
  end

  defp constantize(atom) when is_atom(atom), do: atom |> Atom.to_string() |> Macro.camelize()
end
