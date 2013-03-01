# TODO soon
## Just write your name in front of a task if you're working on it


- what is "all_widgets"?
    * dynamic list of all possible widgets (ie DB)
- dashboard.json: which widgets we want, and their options
- persistance of positions/config...
    client side or server side?
    what about multiple dashboards on the same server?
- when asking for widget data
    need to give configation, instead of using hardcoded URIs

## Andrew's take
- all widgets is all widget archetypes available on the server
- user chooses which widgets they want on the edit screen
- the activated widgets display their options
- activated widgets send their config when asking for widget data
- dashboard config stored in html localstorage (corrolary is that many dashboards can be powered by the same server)

- want to develop plugin architecture for plugins

## Done
- move "size" out of static JSON into client-side template
- move "view" out of static JSON into server widget code


# High level tasks


## Client-side refactor

- Concept of widget

- Concat all scripts (requirejs?)

## New widgets

- Travis CI
- Jira burn-up
- Other ideas?

## Widget authentication

- Support "http basic auth" in addition to guest logins
- Env variables / config files?

## Edit mode

- Show a list of widgets
- Adding widgets
- Removing widgets
- Configure a widget

## Persistance

- Investigate MongoDB

### Widget configuration

- Default size
- Available options (title, url...)
- JSON or DB?

### Dashboard

- List of widgets
- Position, options
- Multipe dashboards
    per instance? per route?

## Modularity

- Think of ways we can easily create new widgets
- Does widget = Server JS + Client JS + HTML template
- How to deliver them easily?

## Design

- make it look better
- better name?
