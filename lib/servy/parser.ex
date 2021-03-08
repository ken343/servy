defmodule Servy.Parser do
  # "as: Conv" is optional because alias scheme is so common
  # it is built in.
  alias Servy.Conv, as: Conv
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{
      method: method,
      path: path,
    }
  end
end
