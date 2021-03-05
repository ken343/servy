defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
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

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv


  def route(%{methd: "GET", path: "/whoop"} = conv) do
    %{conv | status: 200, resp_body: "Foxes"}
  end

  def route(%{method: "GET", path: "/whoop/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Fox: #{id}"}
  end

  def route(%{method: "GET", path: "/hiss"} = conv) do
    %{conv | status: 200, resp_body: "cobra"}
  end

  def route(%{method: "DELETE", path: path} = conv) do
    %{conv | status: 200, resp_body: "Deleting #{path}..."}
  end

  def route(%{path: path} = conv) do
    %{conv | status: 404, resp_body: "Path #{path} does not exist!"}
  end

  def track(%{status: 404, path: path} = conv) do
      IO.puts "Warning #{path} is on the LOOSE."
      conv
  end

  def track(conv), do: conv

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

request6 = """
GET /whaleFish HTTP/1.1
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

response = Servy.Handler.handle(request6)
IO.puts response
