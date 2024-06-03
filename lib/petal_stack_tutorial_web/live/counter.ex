defmodule PetalStackTutorialWeb.Counter do
  use PetalStackTutorialWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end

  attr :click, :string, required: true
  attr :debounce, :integer, default: 20
  slot :inner_block

  defp my_button(assigns) do
    ~H"""
    <button phx-click={@click} phx-debounce={@debounce}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :counter, :integer, required: true

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <span><%= @counter %></span>
      <.my_button click="inc">+</.my_button>
      <.my_button click="dec">-</.my_button>
    </div>
    """
  end

  @impl true
  def handle_event("inc", _params, socket) do
    {:noreply, update(socket, :counter, fn x -> x + 1 end)}
  end

  @impl true
  def handle_event("dec", _params, socket) do
    f = fn
      x when x <= 0 -> 0
      x -> x - 1
    end

    {:noreply, update(socket, :counter, f)}
  end
end
