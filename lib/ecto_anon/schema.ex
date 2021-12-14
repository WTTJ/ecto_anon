defmodule EctoAnon.Schema do
  @moduledoc """
  EctoAnon.Schema lets you define anonymizable fields.
  """
  defmacro __using__(_) do
    quote do
      Module.register_attribute(__MODULE__, :anon_fields, accumulate: true)

      import unquote(__MODULE__)

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def __anon_fields__, do: @anon_fields
    end
  end

  @doc """
  Define an anonymizable field in your Ecto schema. Use it as a replacement of Ecto.Schema.field/3
  """
  defmacro anon_field(name, type \\ :string, opts \\ []) do
    quote do
      EctoAnon.Schema.__anon_field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  def __anon_field__(mod, name, type, opts) do
    anon_with = Keyword.get(opts, :anon_with) |> anon_with()
    ecto_opts = Keyword.delete(opts, :anon_with)

    Ecto.Schema.__field__(mod, name, type, ecto_opts)

    Module.put_attribute(mod, :anon_fields, {name, anon_with})
  end

  defp anon_with(nil), do: EctoAnon.Functions.get_function(:default)
  defp anon_with(function) when is_atom(function), do: EctoAnon.Functions.get_function(function)
  defp anon_with(function) when is_function(function), do: function
end
