defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{method: method,
      path: path,
      status: nil,
      resp_body: "" }
  end

  def log(conv), do: IO.inspect conv

  def route(conv) do
    # TODO: Create a new map that also has the response body:
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/whoop") do
    %{conv | status: 200, resp_body: "Foxes"}
  end

  def route(conv, "GET", "/whoop/" <> id) do
    %{conv | status: 200, resp_body: "Fox: #{id}"}
  end

  def route(conv, "GET", "/hiss") do
    %{conv | status: 200, resp_body: "cobra"}
  end

  def route(conv, "DELETE", path) do
    %{conv | status: 200, resp_body: "Deleting #{path}..."}
  end

  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "Path #{path} does not exist!"}
  end

  def format_response(conv) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{conv.method} #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end


  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end

request1 = """
GET /whoop HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request2 = """
GET /hiss HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request3 = """
GET /wags HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

request4 = """
GET /whoop/elDiablo HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

request5 = """
DELETE /whoop HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
"""

response = Servy.Handler.handle(request1)
IO.puts response

response = Servy.Handler.handle(request2)
IO.puts response

response = Servy.Handler.handle(request3)
IO.puts response

response = Servy.Handler.handle(request4)
IO.puts response

response = Servy.Handler.handle(request5)
IO.puts response
