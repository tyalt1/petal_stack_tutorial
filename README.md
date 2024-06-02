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

## How to use this repo

Either read the full tutorial section below or look at the code commits in isolation as examples.

## Table of Contents

This is a quick summary of each commit. View the commit to look at code in isolation. Each commit will be assigned a section below to go into more detail.

 Section # | Commit | Description
------|------|------
 1 | `12eb0e4` | Ran `mix phx.new petal_stack_tutorial`
 1 | `TBD` | Added `.tool-versions`, wrote PETAL Stack section of README

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
### Section 3: Intro to Ash
### Section 4: TBD
