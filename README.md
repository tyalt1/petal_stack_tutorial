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
- Discord has many examples of using Elixir as thier primay language to scale to a large amount of users. [Source](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)

### Examples of productivity

- The only dependancy is Elixir. Phoenix is built on Elixir, Phoenix comes with a utility to run Tailwind by default, and the other parts of the stack are Elixir packages.
- Elixir features a macro system so that users can do more with less code.
- Phoenix is a batteries included framework that's designed to get started as fast as possible.
  - [Source: Build a real-time twitter clone in 15 minutes](https://www.phoenixframework.org/blog/build-a-real-time-twitter-clone-in-15-minutes-with-live-view-and-phoenix-1-5)
- Including Tailwind means your project starts with over 37,000 CSS classes already defined.
- LiveView handles the connection to between backend and frontend so you don't need to maintain a backend REST API or a Javascript client for your frontend.
- With LiveView developers can write reactive single-page frontends in HTML and Elixir. (No Javascript)
- Ash lets you define a model and then with minimal code derive database persistance, code wrappers, REST API, GraphQL API, and more.

## Table of Contents

This is a summary of notable commits, and sections that go into that code in greater detail.

 Section # | Commit | Description
------|------|------
 1 | [`12eb0e4`](https://github.com/tyalt1/petal_stack_tutorial/commit/12eb0e4dea49628c4dcfa6df3e7c6b6b4c622715) | All files generated by running `mix phx.new petal_stack_tutorial`
 2 | [`d2a1733`](https://github.com/tyalt1/petal_stack_tutorial/commit/d2a17336ceb58cb769fdd052cf838e73a344b453) | LiveView Example
 3 | [`0658c29`](https://github.com/tyalt1/petal_stack_tutorial/commit/0658c2911d7ca8b52ebeabcc8e930d4336edbdf7) | Ash.Resource Example

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

What happens when we click the +
1. The "inc" event is sent via the websocket.
2. We try to call `handle_event/3` and get a function not defined error.
3. The Elixir process dies due to a unhandled exception.
4. The process is restarted by a supervisor and reconnects to our websocket.

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

That is mostly everything you need to get started with LiveView but not all the functionality. Below are notable examples:

- [`Phoenix.LiveComponent`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html) which are components that maintain their own state, handle their own events, and cant be embedded in a LiveView.
- Handle events locally with [`Phoenix.LiveView.JS`](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html)
- [Forms](https://hexdocs.pm/phoenix_live_view/form-bindings.html)
- Implement `handle_info/2` to handle server-side events sent from other processes, for real-time updates to the UI.
- [File uploads](https://hexdocs.pm/phoenix_live_view/uploads.html)
- Lazy-Evaluation style [streaming values](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#stream/4)

### Section 3: Intro to Ash

Ash is used to declare models and derive other functionality from those declarations. A declaration is an `Ash.Resource`. All `Ash.Resource`s are inside an `Ash.Domain`.

We'll follow the [Ash Phoenix tutorial](https://ash-hq.org/docs/guides/ash_phoenix/latest/tutorials/getting-started-with-ash-and-phoenix) for creating a Blog.

#### Ash Boilerplate

Ash is the only element of the PETAL Stack that does not come with Elixir or Phoenix. Install Ash by adding the following and run `mix deps.get`
```elixir
defp deps do
  [
    {:ash, "~> 3.0"},
    {:ash_phoenix, "~> 2.0"},
    {:ash_postgres, "~> 2.0"},
    ...
  ]
end
```

Optionally, make the changes to `.formatter.exs`
```elixir
[
  import_deps: [..., :ash, :ash_phoenix, :ash_postgres],
  ...
]
```

Change the file `lib/petal_stack_tutorial/repo.ex` to contain this.
```elixir
defmodule PetalStackTutorial.Repo do
  use AshPostgres.Repo,
    otp_app: :petal_stack_tutorial

  # Installs extensions that ash commonly uses
  def installed_extensions do
    ["ash-functions", "uuid-ossp", "citext"]
  end
end
```

Note: `otp_app` must be set to the application name.

Remove references to `ecto` in your `mix.exs` `aliases`. Replace `ecto.setup` with `ash.setup`. It should look something like this:
```elixir
defp aliases do
  [
    setup: ["deps.get", "ash.setup", "assets.setup", "assets.build"],
    ...
  ]
end
```

Make the change to the `config/config.exs` files. We need to list all domains. For now we'll add the Blog domain we're adding next.
```elixir
config :petal_stack_tutorial,
  ash_domains: [PetalStackTutorial.Blog]
```

Create the file `lib/petal_stack_tutorial/blog/blog.ex` which will be our `Blog` domain. This domain will contain the Post resource we're adding next.
```elixir
defmodule PetalStackTutorial.Blog do
  use Ash.Domain

  resources do
    resource PetalStackTutorial.Blog.Post
  end
end
```

Now we can create a Post resource.
```elixir
defmodule PetalStackTutorial.Blog.Post do
  use Ash.Resource,
    domain: PetalStackTutorial.Blog,
    data_layer: AshPostgres.DataLayer,
    extensions: []

  postgres do
    table "posts"
    repo PetalStackTutorial.Repo
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at

    attribute :title, :string do
      allow_nil? false
    end

    attribute :content, :string
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:title]
    end

    update :update do
      accept [:content]
    end

    read :get do
      argument :id, :uuid, allow_nil?: false
      get? true # read will only return 1 value, not a list
      filter expr(id == ^arg(:id))
    end
  end
end
```

The syntax for `Ash.Resource` and `Ash.Domain` should look odd. This is not Elixir, this is a DSL defined using Elixir macros. Refer to the [Ash DSL documentation](https://hexdocs.pm/ash/3.0.9/dsl-ash-resource.html) for more info.

#### Deep dive into `Ash.Resource`

Review of what we've done so far
1. We added Ash, AshPhoenix, and AshPostgres as dependancies
2. Added formatting rules for `mix format`
3. Refactored `PetalStackTutorial.Repo` to use `AshPostgres` instead of `Ecto`.
4. Added `ash.setup` to our `setup` mix alias.
5. Add list of domains to our config file, include the Blog domain.
6. Create the Blog domain, which contains the Post resource.
7. Created the Post resource.

The first 4 steps were boiler plate we don't need to touch again. The config file only needs to be updated if we create a new doamin. The domain was made to hold the resource. There isn't much to do in the domain yet. Let's look at the Post resource.

```elixir
use Ash.Resource,
    domain: PetalStackTutorial.Blog,
    data_layer: AshPostgres.DataLayer,
    extensions: []
```

This declares the module to be a `Ash.Resource`. `domain` is the domain module. We've already defined the Blog module. `data_layer` is the module that defines how this module will be persisted. Ash comes with data layers that saves these models in memory, in ETS, and more. The `AshPostgres.DataLayer` is a data layer we installed that writes the value to a Postgres database. `extensions` can be used to add more blocks than what Ash comes with. These can be used to add the `json_api` block for generating REST APIs or the `graphql` block for generating GraphQL APIs. For now we will have no extensions.

```elixir
postgres do
  table "posts"
  repo PetalStackTutorial.Repo
end
```

This block declares the name of the table and what `Repo` module is used to read/write to/from the database.

```elixir
attributes do
  uuid_primary_key :id
  create_timestamp :created_at
  update_timestamp :updated_at

  attribute :title, :string do
    allow_nil? false
  end

  attribute :content, :string
end

actions do
  defaults [:read, :destroy]

  create :create do
    accept [:title, :content]
  end

  update :update do
    accept [:content] # only edit content, not title
  end

  read :get do
    argument :id, :uuid, allow_nil?: false
    get? true # read will only return 1 value, not a list
    filter expr(id == ^arg(:id))
  end
end
```

These are the two blocks every `Ash.Resource` will have. `attributes` is the data and `actions` are the operations and workflows it supports.

Post has the UUID primary key that is auto-generated and included. Post also has the created and updated timestamps that are auto-updated. Finally Post includes two standard attributes: title and content. The title attribute has an additional block include to specify it can not be nil. This validation will be performed on all write actions.

Developers can write CRUD operations in their sleep. Ash writes them for you. `defaults` is a list of default actions added to the resource. We explicitly have a `create` and `update` action so we can state what attributes we can accpet. In `update` we can change the content of the post, but not the title. We can pass both in `create`. We also include another `read` function called `get`. The default `read` function returns a list of all elements, so we also add an extra `read` action called `get` that returns a Post for the given ID.

We need to do one more thing before we run our code. Run the following to generate and run migrations. We'll use "blog_post" as a name of the migrations but it could be anything.
```
mix ash.codegen blog_post
mix ash.setup
```

#### Using `Ash.Resource` in code

Now we can run the following in the console:
```elixir
alias PetalStackTutorial.Blog.Post

# create post
new_post = Post |> Ash.Changeset.for_create(:create, %{title: "hello world"}) |> Ash.create!()

# read all posts
Post |> Ash.Query.for_read(:read) |> Ash.read!()

# get single post by id
Post |> Ash.Query.for_read(:get, %{id: new_post.id}) |> Ash.read_one!()
# OR
Post |> Ash.get!(new_post.id)

# update post
updated_post = new_post |> Ash.Changeset.for_update(:update, %{content: "hello to you too!"}) |> Ash.update!()

# delete post
new_post |> Ash.Changeset.for_destroy(:destroy) |> Ash.destroy!()
```

Here we can change the model with `Ash.Changeset` and read it with `Ash.Query`. We create a `Ash.Changeset` and `Ash.Query` with the name of the module, the name of the action, and additional options like new fields or filtering criteria. We then pass this to the correct `Ash` function to run the action. All the callbacks are either implented by Ash or derived from the `attributes` and `actions` blocks. All of these actions are reading and writing values to/from the given Data Layer, in this case Postgres.

This is a lot of code. We can define wrappers with the `code_interface` block in the resource. However for now we'll only define them as part of the domain. Change the Blog doamin to now contain.

```elixir
defmodule PetalStackTutorial.Blog do
  use Ash.Domain

  resources do
    resource PetalStackTutorial.Blog.Post do
      define :create_post, action: :create
      define :list_posts, action: :read
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, action: :get, args: [:id]
    end
  end
end
```

The line `define :create_post, action: :create` defines a function called `create_post` that will run the `create` action for the `Post` resource. The other defines work similarly.

Now we can use the Blog domain functions to run the actions of Post.
```elixir
alias PetalStackTutorial.Blog

# create post
new_post = Blog.create_post!(%{title: "hello world"})

# read post
Blog.list_posts!()

# get post by id
Blog.get_post!(new_post.id)

# update post
updated_post = Blog.update_post!(new_post, %{content: "hello to you too!"})

# delete post
Blog.destroy_post!(updated_post)
```

The implementation of these actions are only defined once in the `actions` block of the Post resource. This lays the foundation for deriving more functionality from these actions. We could also create other resources and domains.

In further sections I'll discuss
- User and Login with `AshAuthentication`
- Integrating Ash models with LiveView forms
- REST API with `AshJsonApi`
- GraphQL API with `AshGraphql`

### Section 4: TBD
