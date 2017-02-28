defmodule Identicon do
  @moduledoc """
  Generates, string based, a icon.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [first, second]
  end

  @doc """
  Receives a Identicon.Image struct and returns new one with RGB color.

  ## Examples

      iex> image = Identicon.hash_input("banana")
      %Identicon.Image{color: nil,
       hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
      iex> Identicon.pick_color(image)
      %Identicon.Image{color: {114, 179, 2},
       hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Receives a string and returns a list of the encrypted numbers.

  ## Examples

      iex> Identicon.hash_input("banana")
      %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{ hex: hex }
  end
end
