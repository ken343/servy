defmodule Servy.Handler do
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  alias Servy.Conv, as: Conv

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  @pages_path Path.expand("../../pages", __DIR__)
  def route(%Conv{method: "GET", path: "/whoop"} = conv) do
    %{conv | status: 200, resp_body: "Foxes"}
  end

  def route(%Conv{method: "GET", path: "/whoop/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Fox: #{id}"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    file = Path.join(@pages_path, "about.html")

    case File.read(file) do

      {:ok, content} -> %{conv | status: 200, resp_body: content}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "File not founnd!"}
      {:error, reason} -> %{conv | status: 500, resp_body: "File error #{reason}"}

    end
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/hiss"} = conv) do
    %{conv | status: 200, resp_body: "cobra"}
  end

  def route(%Conv{method: "DELETE", path: path} = conv) do
    %{conv | status: 200, resp_body: "Deleting #{path}..."}
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "Path #{path} does not exist!"}
  end

  def format_response(%Conv{} = conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

request = """
GET /whoop HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /hiss HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /wags HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /whoop/elDiablo HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
DELETE /whoop HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /whaleFish HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request)
IO.puts response

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
IO.puts response
