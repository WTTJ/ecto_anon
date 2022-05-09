defmodule EctoAnon.Schema do
  @moduledoc """
  EctoAnon.Schema lets you define anonymizable fields.
  """
  defmacro __using__(_) do
    quote do
      Module.register_attribute(__MODULE__, :anon_fields, accumulate: true)
      @before_compile unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def __anon_fields__, do: @anon_fields
    end
  end

  defmacro anon_config(fields_config) do
    quote do
      EctoAnon.Schema.__anon_config__(__MODULE__, unquote(fields_config))
    end
  end

  def __anon_config__(mod, fields_config) do
    fields_config
    |> Enum.each(&Module.put_attribute(mod, :anon_fields, anon_with(&1)))
  end

  defp anon_with(field) when is_atom(field),
    do: {field, {EctoAnon.Functions.get_function(:default), []}}

  defp anon_with({field, function}) when is_atom(field) and is_atom(function),
    do: {field, {EctoAnon.Functions.get_function(function), []}}

  defp anon_with({field, function}) when is_atom(field) and is_function(function),
    do: {field, {function, []}}

  defp anon_with({field, opts}) when is_atom(field) and is_list(opts) do
    case Keyword.get(opts, :with) do
      nil ->
        {field, opts}

      [{function, params}] when is_atom(function) ->
        {field, {EctoAnon.Functions.get_function(function), [params]}}

      [{function, params}] ->
        {field, {function, [params]}}
    end
  end
end
