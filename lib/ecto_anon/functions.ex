defmodule EctoAnon.Functions do
  @moduledoc """
  This module is in charge of the function attribution.
  """

  @doc """
  Returns the right anonymizing module.
  """
  def get_module(atom) do
    Module.safe_concat(__MODULE__, constantize(atom))
  end

  def get_function(atom) when is_atom(atom) do
    mod = get_module(atom)

    &mod.run/1
  end

  defp constantize(atom), do: atom |> Atom.to_string() |> Macro.camelize()
end
