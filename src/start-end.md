{% import "templates/bulma.tera" as bulma %}

# Moving to the beginning of a function

{{ bulma::begin_bulma() }}
{{ bulma::tags(tags=[
  bulma::reven_version(version="v2.9.0"),
]) }}
{{ bulma::end_bulma() }}

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
