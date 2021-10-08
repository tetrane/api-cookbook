# Finding more about the semantics of an instruction

<div class="bulma">
  <div class="message is-link">
     <div class="message-header">
         Related examples
     </div>
     <div class="message-body content pt-0">
        <ul>
            <li><a href="../examples-book/analyze/vulnerability_detection/detect_use_after_free.html">Use-after-Free vulnerabilities detection</a></li>
            <li><a href="../examples-book/analyze/vulnerability_detection/detect_buffer_overflow.html">Searching for Buffer-Overflow vulnerabilities</a></li>
            <li><a href="../examples-book/analyze/vulnerability_detection/detect_use_of_uninitialized_memory.html">Searching for Use-of-Uninitialized-Memory vulnerabilities</a></li>
        </ul>
     </div>
  </div>
</div>

## Pre-requisites: install and setup Capstone

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Environment</span>
      <span class="tag is-info">Jupyter</span>
    </div>
  </div>
</div>
</div>

This example requires the `capstone` Python package:

```py
# From a code cell of a Jupyter notebook
try:
    import capstone
    print("capstone already installed")
except ImportError:
    print("Could not find capstone, attempting to install it from pip")
    import sys

    output = !{sys.executable} -m pip install capstone; echo $?  # noqa
    success = output[-1]

    for line in output[0:-1]:
        print(line)

    if int(success) != 0:
        raise RuntimeError("Error installing capstone")
    import capstone
    print("Successfully installed capstone")
```

## Using Capstone

Since we need to maintain several objects that we would need to pass to the various functions, the easiest way is to use classes:

```py
class DisassembledInstruction:
    def __init__(self, _tr : reven2.trace.Transition, _cs_insn):
        self._tr = _tr
        self._cs_insn = _cs_insn

    def _read_transition_reg(self, reg: reven2.arch.register.Register):
        """
        Read the value of a register during computations performed by the instruction.

        For PC, it is the value after the instruction.
        For other registers, it is the value before the instruction.
        """
        if reg in [reven2.arch.x64.rip, reven2.arch.x64.eip]:
            return self._tr.pc + self._cs_insn.size
        else:
            return self._tr.context_before().read(reg)

    def dereferenced_address(self, op_index: int):
        from reven2.arch.register import Register

        cs_op = self._cs_insn.operands[op_index]

        if cs_op.type != capstone.CS_OP_MEM:
            raise IndexError("The selected operand is not a memory operand")

        dereferenced_address = 0

        if cs_op.value.mem.base != 0:
            base_reg = Register.from_name(self._cs_insn.reg_name(cs_op.value.mem.base))
            dereferenced_address += self._read_transition_reg(base_reg)

        if cs_op.value.mem.index != 0:
            index_reg = Register.from_name(self._cs_insn.reg_name(cs_op.value.mem.index))
            index = self._read_transition_reg(index_reg)
            dereferenced_address += (cs_op.value.mem.scale * index)

        dereferenced_address += cs_op.value.mem.disp

        # mask instruction depending on mode
        mask = 0xFFFF_FFFF_FFFF_FFFF if self._tr.mode == reven2.trace.Mode.X86_64 else 0xFFFF_FFFF

        return dereferenced_address & mask

    @property
    def capstone_instruction(self):
        return self._cs_insn

    @property
    def transition(self):
        return self._tr


class Disassembler:
    def __init__(self):
        self._md_64 = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
        self._md_64.detail = True

        self._md_32 = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        self._md_32.detail = True

    def disassemble(self, tr: reven2.trace.Trace):
        """
        Attempt to disassemble with Capstone the instruction associated to the passed transition.

        Returns None if there is no instruction to disassemble.
        """
        if tr.instruction is not None:
            instruction = tr.instruction
        elif tr.exception is not None and tr.exception.related_instruction is not None:
           instruction = tr.exception.related_instruction
        else:
            return None

        if tr.mode == reven2.trace.Mode.X86_64:
            md = self._md_64
        elif tr.mode == reven2.trace.Mode.X86_32:
            md = self._md_32
        else:
            raise ValueError("Unsupported mode '{tr.mode}'")
        cs_insn = next(md.disasm(instruction.raw, instruction.size))

        return DisassembledInstruction(tr, cs_insn)
```

## Disassembling REVEN instructions

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
      <span class="tag is-dark">Dependency</span>
      <span class="tag is-info">capstone</span>
    </div>
  </div>
</div>
</div>

```py
dsm = Disassembler
insn = dsm.disassemble(tr)
# Access the capstone instruction
insn.capstone_instruction
```

Depending on your use-case you may want to skip disassembling instructions related to exceptions, as these are not always (fully) executed.

## Compute dereferenced address

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Dependency</span>
      <span class="tag is-info">capstone</span>
    </div>
  </div>
</div>
</div>

```py
hex(insn.dereferenced_address(0))
```

Sample output:

```
'0xfffff8024cfacfb0'
```

## Convert capstone flags to REVEN register flags

<div class="bulma">
<div class="field is-grouped is-grouped-multiline">
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">REVEN</span>
      <span class="tag is-info">v2.2.0</span>
    </div>
  </div>
  <div class="control">
    <div class="tags has-addons">
      <span class="tag is-dark">Dependency</span>
      <span class="tag is-info">capstone</span>
    </div>
  </div>
</div>
</div>

```py
test_eflags = {
    capstone.x86.X86_EFLAGS_TEST_OF: reven2.arch.x64.of,
    capstone.x86.X86_EFLAGS_TEST_SF: reven2.arch.x64.sf,
    capstone.x86.X86_EFLAGS_TEST_ZF: reven2.arch.x64.zf,
    capstone.x86.X86_EFLAGS_TEST_PF: reven2.arch.x64.pf,
    capstone.x86.X86_EFLAGS_TEST_CF: reven2.arch.x64.cf,
    capstone.x86.X86_EFLAGS_TEST_NT: reven2.arch.x64.nt,
    capstone.x86.X86_EFLAGS_TEST_DF: reven2.arch.x64.df,
    capstone.x86.X86_EFLAGS_TEST_RF: reven2.arch.x64.rf,
    capstone.x86.X86_EFLAGS_TEST_IF: reven2.arch.x64.if_,
    capstone.x86.X86_EFLAGS_TEST_TF: reven2.arch.x64.tf,
    capstone.x86.X86_EFLAGS_TEST_AF: reven2.arch.x64.af,
}

for flag, reg in test_eflags.items():
    if not insn.capstone_instruction.eflags & flag:
        # register not present, skip
        continue
    print(f"{reg} is affected by the instruction")
```
