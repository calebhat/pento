defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    number = random()
    {:ok, assign(socket, score: 0, message: "Make a guess", time: "", winner: number)}
  end

  def random() do
    x = :rand.uniform(10)
    IO.puts(x)
    if x > 0, do: x, else: random()
  end

  def render(assigns) do
    ~H"""
      <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
        <h2>
        <%= @message %>
        It's <%= @time %>
        </h2>
      <br/>
      <h2>
        <%= for n <- 1..10 do %>
          <.link class="bg-blue-500 hover:bg-blue-700
            text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            phx-click="guess" phx-value-number= {n} >
            <%= n %>
          </.link>
        <% end %>
      </h2>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    winner = socket.assigns.winner
    guess = String.to_integer(guess) #from js is a string always
    time = time()
    case {guess, winner} do
      {winner, winner} ->
        message = "Wining guess: #{guess}. Congrats! "
        score = socket.assigns.score + 1
        IO.puts("yes")
        {
          :noreply,
          assign(
            socket,
            message: message,
            score: score,
            time: time,
            winner: random())}
      _ ->
        message = "Looser: #{guess}. Guess Again "
        score = socket.assigns.score - 1
        {
          :noreply,
          assign(
            socket,
            message: message,
            score: score,
            time: time)}
    end
  end

end
