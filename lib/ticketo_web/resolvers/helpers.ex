defmodule TicketoWeb.Resolvers.Helpers do
  @moduledoc """
  Helpers to be used in the resolver functions.
  """
  def error_response(message, changeset) do
    {:error, message: message, details: error_details(changeset)}
  end

  defp error_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &replace_keys_in_message/1)
  end

  defp replace_keys_in_message({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
