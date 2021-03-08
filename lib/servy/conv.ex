defmodule Servy.Conv do
  # Brackets are optional because macro takes list only.
  defstruct [method: "", path: "", resp_body: "", status: nil]

  def full_status(conv) do
    "#{conv.method} #{conv.status} #{status_reason(conv.status)}"
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
