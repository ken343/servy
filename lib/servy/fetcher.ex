defmodule Servy.Fetcher do
    def async(fun) do
        parent = self()
        # Monkey way of doing it without abstraction
        spawn(fn -> send(parent, {self(), :result, fun.()}) end)
    end

    def get_result(pid) do
        receive do {^pid, :result, value} -> value end
    end
end