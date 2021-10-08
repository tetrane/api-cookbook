# Moving to the beginning of a function

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.9.0</span>
    </div>
  </div>
</div>
</div>

```py
from reven2.trace import Transition
from typing import Tuple, Optional

def call_bounds(tr: Transition) -> Tuple[Optional[Transition], Optional[Transition]]:
    """
    Given a transition anywhere inside of a function, this function returns
    the transition at the beginning of the function call and the transition at
    the end of the function call.
    """
    return (tr.step_out(is_forward=False), tr.step_out(is_forward=True))
```
