{% import "templates/bulma.tera" as bulma %}

# Manipulating transitions and contexts

## Getting a transition or context from a transition id

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.2.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
tr = server.trace.transition(1234)
ctx_before = server.trace.context_before(1234)
ctx_after = server.trace.context_after(1234)
```

## Context <-> Transition

### Transition -> Context

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.2.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
ctx_before = tr.context_before()
ctx_after = tr.context_after()
```

### Context -> Transition

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.6.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
if ctx != server.trace.first_context:
    tr_before = ctx.transition_before()
if ctx != server.trace.last_context:
    tr_after = ctx.transition_after()
```

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.2.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
if ctx != server.trace.context_before(0):
    tr_before = ctx.transition_before()
if ctx != server.trace.context_after(server.trace.transition_count - 1):
    tr_after = ctx.transition_after()
```

{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="There are not always transitions around a context", class="is-warning") }}
<p>
  While <code>transition.context_before/context_after()</code> always works, one must handle the case where a context is the first/last of the trace, in which case no transition before/after it can be accessed.
</p>
<p>
  Trying to access the transition before the first context/after the last, will trigger an <code>IndexError</code>.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}

## Getting the next/previous context and transition

```py
next_tr = tr + 1
prev_tr = tr - 1
next_ctx = ctx + 1
prev_ctx = ctx - 1
next_next_tr = tr + 2
# ...
```

{{ bulma::begin_bulma() }}
{{ bulma::begin_message(header="There is not always a next/previous transition/context", class="is-warning") }}
<p>
  Make sure that the resulting transition/context is in range when adding/subtracting an offset to generate a new transition/context.
</p>
<p>
  Trying to access a transition/context out-of-range will trigger an <code>IndexError</code>.
</p>
{{ bulma::end_message() }}
{{ bulma::end_bulma() }}

## Iterating on a range of transitions/contexts

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.2.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
for tr in server.trace.transitions(0, 1000):
    print(tr)

for ctx in server.trace.contexts():
    print(ctx)
```

# Getting the first/last context/transition in the trace

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.6.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
first_tr = server.trace.first_transition
last_tr = server.trace.last_transition
first_ctx = server.trace.first_context
last_ctx = server.trace.last_context
```

{{ bulma::begin_bulma() }}
    {{ bulma::tags(tags=[
        bulma::reven_version(version="v2.2.0"),
    ]) }}
{{ bulma::end_bulma() }}

```py
first_tr = server.trace.transition(0)
last_tr = server.trace.transition(server.trace.transition_count - 1)
first_ctx = server.trace.context_before(0)
last_ctx = server.trace.context_after(server.trace.transition_count - 1)
```
