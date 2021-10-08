# Displaying the value of arguments and return value of a call

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.10.0</span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">API</span>
      <span class="tag is-warning">preview</span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">OS</span>
      <span class="tag is-primary icon-text">
        <span class="icon"><i class="fa fa-windows" aria-hidden="true"></i></span>
        <span>Windows 64-bit</span>
      </span>
    </div>
  </div>

  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">OS</span>
      <span class="tag is-primary icon-text">
        <span class="icon"><i class="fa fa-linux" aria-hidden="true"></i></span>
        <span>Linux 64-bit</span>
      </span>
    </div>
  </div>
</div>

  <div class="message is-link">
     <div class="message-header">
         Related examples
     </div>
     <div class="message-body content pt-0">
        <ul>
            <li>(GitHub) <a href="https://github.com/tetrane/reven2-ltrace">ltrace</a></li>
            <li>(GitHub) <a href="https://github.com/tetrane/reven2-file-activity">File activity</a></li>
        </ul>
     </div>
  </div>

</div>

## When the prototype is known

### Windows 64-bit

Use the `Ms64` calling convention.

```py
call_tr = tr.step_out(is_forward=False)
import reven2.preview.prototypes
prototypes = reven2.preview.prototypes.RevenPrototypes(server)
call_conv = prototypes.calling_conventions.Ms64
prototype = "char * __cdecl OaGetEnv(char const *)"
f = prototypes.parse_one_function(prototype, call_conv)
call = f.call_site_values(call_tr)
call.arg_n(0)
call.ret()
```

Sample output:

```py
'OACACHEPARAMS'
0
```

### Linux 64-bit

Use the `Sysv64` calling convention.

```py
call_tr = tr.step_out(is_forward=False)
import reven2.preview.prototypes
prototypes = reven2.preview.prototypes.RevenPrototypes(server)
call_conv = prototypes.calling_conventions.Sysv64
prototype = "struct FILE; FILE* fopen64(const char *filename, const char *mode);"
f = prototypes.parse_one_function(prototype, call_conv)
call = f.call_site_values(call_tr)
call.args()
call.ret()
```

Sample output:

```py
{'filename': '/proc/spl/kstat/zfs/arcstats', 'mode': 'r'}
0
```

## Using a default prototype

Example with 5 parameters.

```py
call_tr = tr.step_out(is_forward=False)
import reven2.preview.prototypes
prototypes = reven2.preview.prototypes.RevenPrototypes(server)
call_conv = prototypes.calling_conventions.Ms64
prototype = "void* f(void* p0, void* p1, void* p2, void* p3, void* p4);"
f = prototypes.parse_one_function(prototype, call_conv)
call = f.call_site_values(call_tr)
call.args()
call.ret()
```

Sample output:

```py
{'p0': 18446735287469384880,
 'p1': 0,
 'p2': 18446735287473289024,
 'p3': 0,
 'p4': 0}
1364968393473
```

<div class="bulma">
  <div class="message is-warning">
     <div class="message-header">
         Limitations apply
     </div>
     <div class="message-body content">
       <p>
       Using a default prototype works as long as the replaced parameters behave as <code>void*</code>.
       </p><p>
       This is notably not the case for structs passed by value that are larger than a pointer (in some calling conventions) and for floating-point arguments (in Sysv64).
      </p></div>
  </div>
</div>
