# Manipulating transitions and contexts

## Getting a transition or context from a transition id

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
</div></div>

```py
tr = server.trace.transition(1234)
ctx_before = server.trace.context_before(1234)
ctx_after = server.trace.context_after(1234)
```

## Context <-> Transition

### Transition -> Context

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
</div></div>

```py
ctx_before = tr.context_before()
ctx_after = tr.context_after()
```

### Context -> Transition

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.6.0</span>
    </div>
  </div>
</div></div>

```py
if ctx != server.trace.first_context:
    tr_before = ctx.transition_before()
if ctx != server.trace.last_context:
    tr_after = ctx.transition_after()
```

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
</div></div>

```py
if ctx != server.trace.context_before(0):
    tr_before = ctx.transition_before()
if ctx != server.trace.context_after(server.trace.transition_count - 1):
    tr_after = ctx.transition_after()
```

<div class="bulma">
  <div class="message is-warning">
     <div class="message-header">
         There are not always transitions around a context
     </div>
     <div class="message-body content">
       <p>
       While <code>transition.context_before/context_after()</code> always works, one must handle the case where a context is the first/last of the trace, in which case no transition before/after it can be accessed.
       </p><p>
       Trying to access the transition before the first context/after the last, will trigger an <code>IndexError</code>.
       </p></div>
  </div>
</div>


## Getting the next/previous context and transition

```py
next_tr = tr + 1
prev_tr = tr - 1
next_ctx = ctx + 1
prev_ctx = ctx - 1
next_next_tr = tr + 2
# ...
```

<div class="bulma">
  <div class="message is-warning">
     <div class="message-header">
         There is not always a next/previous transition/context
     </div>
     <div class="message-body content">
       <p>
       Make sure that the resulting transition/context is in range when adding/subtracting an offset to generate a new transition/context.
       </p><p>
       Trying to access a transition/context out-of-range will trigger an <code>IndexError</code>.
       </p></div>
  </div>
</div>

## Iterating on a range of transitions/contexts

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
</div></div>

```py
for tr in server.trace.transitions(0, 1000):
    print(tr)

for ctx in server.trace.contexts():
    print(ctx)
```

# Getting the first/last context/transition in the trace

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.6.0</span>
    </div>
  </div>
</div></div>

```py
first_tr = server.trace.first_transition
last_tr = server.trace.last_transition
first_ctx = server.trace.first_context
last_ctx = server.trace.last_context
```

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
</div></div>

```py
first_tr = server.trace.transition(0)
last_tr = server.trace.transition(server.trace.transition_count - 1)
first_ctx = server.trace.context_before(0)
last_ctx = server.trace.context_after(server.trace.transition_count - 1)
```
