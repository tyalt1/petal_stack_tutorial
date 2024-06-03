# Petal Stack Tutorial

This is tutorial repo for the learning the PETAL stack.

Disclaimer: This stack does not use Alpine.js. The A in the PETAL stack usually refers to Alpine.js however Alpine.js is typically no longer used in Phoenix applications because of additional functionallity added to LiveView, specifically in the `Phoenix.LiveView.JS` module. This stack adds the use of the Ash framework, as it helps declare models quickly and derive functionality with minimal code. And because it starts with an A.

## PETAL Stack

Letter | Name/Link | Description
------|------|------
P | [Phoenix](https://www.phoenixframework.org/) | Server-sided web framework built in Elixir.
E | [Elixir](https://hexdocs.pm/elixir/introduction.html) | Functional, concurrent, high-level programming language that runs on the Erlang (BEAM) virtual machine.
T | [Tailwind](https://tailwindcss.com/) | Utility-first CSS framework.
A | [Ash](https://ash-hq.org/) | Declarative model framework for Elixir.
L | [LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) | Library for creating UIs in declarative HTML and updated via websocket events.

## Why the PETAL stack?

The PETAL stack is scalable and productive.

### Examples of scalability

Elixir runs on the Erlang VM which has many examples of scalability

- The company that created Erlang boasts only 5.2 minutes of downtime a year in their systems running Erlang.
- Whatsup was able to maintain 2 million TCP connections on a single server using 40% CPU of a server from 2012 using Erlang. [Source](https://blog.whatsapp.com/1-million-is-so-2011)
- A developer rewrote an AWS microservice application in Elixir. The resulting application was faster and cost less to run in the cloud. [Source](https://medium.com/coryodaniel/from-erverless-to-elixir-48752db4d7bc)
- Discord as many examples of using Elixir as thier primay language to scale to a large amount of users. [Source](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)

### Examples of productivity

- The only dependancy is Elixir. Phoenix is built on Elixir, Phoenix comes with a utility to run Tailwind by default, and the other parts of the stack are Elixir packages.
- Elixir features a macro system so that users can do more with less code.
- Phoenix is a batteries included framework that's designed to get started as fast as possible.
  - [Source: Build a real-time twitter clone in 15 minutes](https://www.phoenixframework.org/blog/build-a-real-time-twitter-clone-in-15-minutes-with-live-view-and-phoenix-1-5)
- Including Tailwind means your project starts with over 37,000 CSS classes already defined.
- LiveView handles the connection to between backend and frontend so you don't need to maintain a backend REST API or a frontend Javascript client for your frontend.
- With LiveView developers can write reactive single-page frontends in HTML and Elixir. (No Javascript)
- Ash lets you define a model and then with minimal code derive database persistance, code wrappers, REST API, GraphQL API, and more.

## Table of Contents

This is a summary of notable commits, and sections that go into that code in greater detail.

 Section # | Commit | Description
------|------|------
 1 | [`12eb0e4`](https://github.com/tyalt1/petal_stack_tutorial/commit/12eb0e4dea49628c4dcfa6df3e7c6b6b4c622715) | All files generated by running `mix phx.new petal_stack_tutorial`
 2 | [`d2a1733`](https://github.com/tyalt1/petal_stack_tutorial/commit/d2a17336ceb58cb769fdd052cf838e73a344b453) | LiveView Example

## Tutorial

### Section 1: Setup Elixir and Phoenix

Install Elixir
```bash
# install asdf (a tool for managing runtimes)
# Getting started: https://asdf-vm.com/guide/getting-started.html

# install erlang and elixir plugins
asdf plugin add erlang
asdf plugin add elixir

# install specific version for plugin
asdf install $PLUGIN $VERSION

# or if you have a .tool-versions file
# install from .tool-versions file
asdf install
```

Create a new Phoenix Project
```bash
# install Hex (Elixir package manager, like npm or pip)
mix local.hex

# update hex and install Phoenix creation script
mix archive.install hex phx_new

# create a new phoenix app
mix phx.new my_app

# set elixir versions, this will create a .tool-versions file
asdf local erlang 26.2.4
asdf local elixir 1.16.2-otp-26
```

Run the server
```bash
# run Postgres via Docker
docker run -d \
  --name phx_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_HOST_AUTH_METHOD=trust \
  -p 5432:5432 \
  postgres

# install dependencies, run migrations
mix setup

# run the server
mix phx.server

# run the server and a console
iex -S mix phx.server
```

### Section 2: Intro to LiveView

We're going to implement a simple counter.

In newer version of Pheonix, LiveView comes included so there is no new dependency needed.

The file `lib/petal_stack_tutorial_web/router.ex` contains the routing logic to associate controllers with verb-path pairs. Add the following line to add a new route that will point to our live view.

```elixir
live "/counter", Counter
```

Create a new file `lib/petal_stack_tutorial_web/live/counter.ex` with the following content
```elixir
defmodule PetalStackTutorialWeb.Counter do
  use PetalStackTutorialWeb, :live_view

  # more code here
end
```

Note: `use PetalStackTutorialWeb, :live_view` inserts `use Phoenix.LiveView` which makes this a live view.

We need to implement minimum 3 callbacks.
- `mount/3` which is called when the websocket is mounted, and returns the inital state.
- `render/1` which takes the state and returns HEEx (HTML Embedded Elixir) template.
- `handle_update/3` which handles events and updates the state.

Implment the `mount/3` function.
```elixir
@impl true
def mount(_params, _session, socket) do
  {:ok, assign(socket, counter: 0)}
end
```

Note: Add the `@impl true` to explicitly say you're implementing a callback.

`mount/3` must return a tuple with `:ok` being first and the socket object being the second. Inside the socket object is a hashmap called `assigns` which we can add state to. The helper function `assign` takes a socket and a key-value and returns a socket object with the updated state. There is other information about the websocket connection in the socket object but we will only care about our own custom state for this exercise.

Implment the `render/1` function.
```elixir
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
```

Note: The `~H` sigil is a macro that turns the string into a HEEx template.

Note: The `@` is a macro that accesses the assigns map. `@counter` is equivalent to `assigns[:counter]`.

Note: When displaying a Elixir value in a HEEx template, use `<%= ... %>` for values in HTML and `{ ... }` for values as attributes.

We implement the `render/1` function that take the assigns map in the socket object. It returns an HEEx template. The template consists of a span to display the value of the counter, and two buttons to increment and decrement the counter. The two buttons have some similar functionality so we can implment another function that is private and returns the button. The `attr` and `slot` macros are helpers for declaring values in the assigns map. A `attr` can be a value that is required or have a default value. You will get a compiler error if a required `attr` is not given. A `slot` is nested HTML.

After we implmented this function, we can start the server and open http://localhost:4000/counter in out browser.

We see the following logs.
```
[info] GET /counter
[debug] Processing with PetalStackTutorialWeb.Counter.Elixir.PetalStackTutorialWeb.Counter/2
  Parameters: %{}
  Pipelines: [:browser]
[info] Sent 200 in 28ms
[info] CONNECTED TO Phoenix.LiveView.Socket in 12µs
  Transport: :websocket
  Serializer: Phoenix.Socket.V2.JSONSerializer
  Parameters: %{"_csrf_token" => "Bwg5ATcfGAQMIHJEPC5OGzYDIUYwcHlXcypQuqhSgj6teC7IpuU7fEL3", "_live_referer" => "undefined", "_mounts" => "0", "_track_static" => %{"0" => "http://localhost:4000/assets/app.css", "1" => "http://localhost:4000/assets/app.js"}, "vsn" => "2.0.0"}
[debug] MOUNT PetalStackTutorialWeb.Counter
  Parameters: %{}
  Session: %{"_csrf_token" => "dqIPBnpWkJD0YmyRFvtqV55d"}
[debug] Replied in 87µs
```

Here we see the following
1. The browser makes a `GET` to `/counter`
2. The router routes to the `Counter` live view.
3. A response is made in 28ms, which sends the LiveView response.
4. That response sends another request to establish a websocket connection.
5. Connect in 12µs
6. The `mount/3` callback is called to initialize the state.
7. The `render/1` callback is called rendering the HTML. This reply is sent in 87µs.

The web page displays "0+-"

Recall we set the `phx-click` and `phx-debounce` attributes on the buttons, which are specific Phoenix LiveView attributes. `phx-click` for the + button is set to the string "inc", which means when that element is clicked that string will be sent via the websocket as an event. The `phx-debounce` attribute is set to 20, which is how many milliseconds all events for this element are debounced for. When we click the + we see the following error.

```
[error] GenServer #PID<0.804.0> terminating
** (UndefinedFunctionError) function PetalStackTutorialWeb.Counter.handle_event/3 is undefined or private
```

What happens
1. We click the +
2. The "inc" event is sent via the websocket.
3. We try to call `handle_event/3` and get a function not defined error.
4. The Elixir process dies due to a unhandled exception.
5. The process is restarted by a supervisor and reconnects to our websocket.

You will see a small red flash alert telling you the page loses connection for a moment, then disappear when the connection is reestablished.

Let's implment `handle_event/3`
```elixir
@impl true
def handle_event("inc", _params, socket) do
  {:noreply, update(socket, :counter, fn x -> x+1 end)}
end

@impl true
def handle_event("dec", _params, socket) do
  f = fn
    x when x <= 0 -> 0
    x -> x - 1
  end
  {:noreply, update(socket, :counter, f)}
end
```

We use pattern matching to implment the function across 2 seperate clauses. Here if we were to emit an event besides "inc" or "dec" from our frontend we'd get a function undefined exception. Optionally we could add a thrid catch-all clause to log the result. In both callbacks we use the `update` helper function to take the socket, key of value we want to change, and a function that will transform the value. We use pattern matching to implment the callback so that it can't decrement below 0.

Now when we click the + button we see the log and the counter update.
```
[debug] HANDLE EVENT "inc" in PetalStackTutorialWeb.Counter
  Parameters: %{"value" => ""}
[debug] Replied in 413µs
```

That is most everything you need to get started with LiveView but not all the functionality

- Implement `handle_info/2` to handle server-side events sent from other processes, for real-time updates to the UI.
- File upload
- Lazy-Evaluation style streaming values
- Local events handled by `Phoenix.LiveView.JS`

### Section 3: Intro to Ash

### Section 4: TBD
