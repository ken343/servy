defmodule Servy.Plugins do
  alias Servy.Conv
  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildstuff"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv

  def track(%Conv{status: 404, path: path} = conv) do
      IO.puts "Warning #{path} is on the LOOSE."
      conv
  end

  def track(conv), do: conv

end
