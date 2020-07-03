defmodule DazzleWeb.TickerLive.FormData do
  defstruct [string: "Be Happy", count: 20]
  @types %{string: :string, count: :integer}
  
  def new(string, count) do
    %{string: string, count: count}
  end
  
  def change(form, params) do
    {form, @types}
    |> Ecto.Changeset.cast(params, Map.keys(@types))
    |> Ecto.Changeset.validate_length(:string, min: 4, max: 12)
    |> Ecto.Changeset.validate_required([:string, :count])
    |> Ecto.Changeset.validate_number(:count, greater_than: 0, less_than: 361)
    |> Map.put(:action, :validate)
  end
end