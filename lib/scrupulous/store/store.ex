defmodule Store do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, {:via, :swarm, __MODULE__}, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_call({:has_key, key}, _, state) do
    {:reply, Map.has_key?(state, key), state}
  end

  def handle_call({:get_between, key, s, e}, _, state) do
    book = Map.get(state, key)
    lines = book |> Enum.reduce_while([], fn(line, acc) -> add_line?(line, acc, s, e) end)
    {:reply, lines, state}
  end

  def handle_call(:get_all, _, state) do
    {:reply, state, state}
  end

  def handle_call(:keys, _, state) do
    {:reply, Map.keys(state), state}
  end

  def handle_call({:search, key, term}, _, state) do
    lines = Map.get(state, key)
            |> Stream.filter(fn({_line, txt}) -> String.contains?(String.downcase(txt), String.downcase(term)) end)
            |> Enum.to_list()
    {:reply, lines, state}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:remove, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

#  Helpers
  def add_line?({line, txt}, acc, s, e) when line >= s and line <= e do
    {:cont, acc ++ [{line, txt}]}
  end

  def add_line?({line, _txt}, acc, _s, e) when line > e do
    {:halt, acc}
  end

  def add_line?(_line, acc, _s, _e) do
    {:cont, acc}
  end


#  Interface
  def get(pid, key) do
    StoreHelpers.fetch_book_if_not_present(pid, key, &put/3)
    GenServer.call(pid, {:get, key})
  end

  def remove(pid, key) do
    GenServer.cast(pid, {:remove, key})
  end

  def get_between(pid, key, s, e) do
    StoreHelpers.fetch_book_if_not_present(pid, key, &put/3)
    GenServer.call(pid, {:get_between, key, s, e})
  end

  def search(pid, key, term) do
    GenServer.call(pid, {:search, key, term})
  end

  def put(pid, key, value) do
    IO.inspect("PUTTING IN KEY #{key}")
    GenServer.cast(pid, {:put, key, value})
  end

  def all(pid) do
    GenServer.call(pid, :get_all)
  end

  def has_key(pid, key) do
    GenServer.call(pid, {:has_key, key})
  end

  def keys(pid) do
    GenServer.call(pid, :keys)
  end

  def pid do
    Process.whereis(__MODULE__)
  end

  def calc_memory_mb(pid) do
    stats = Process.info(pid)
    value_in_bytes = stats[:total_heap_size]
    round(value_in_bytes / 125000)
  end

end
