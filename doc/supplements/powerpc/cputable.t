@c
@c  COPYRIGHT (c) 1988-1996.
@c  On-Line Applications Research Corporation (OAR).
@c  All rights reserved.
@c
@c  $Id$
@c

@ifinfo
@node Processor Dependent Information Table, Processor Dependent Information Table Introduction, Board Support Packages Processor Initialization, Top
@end ifinfo
@chapter Processor Dependent Information Table
@ifinfo
@menu
* Processor Dependent Information Table Introduction::
* Processor Dependent Information Table CPU Dependent Information Table::
@end menu
@end ifinfo

@ifinfo
@node Processor Dependent Information Table Introduction, Processor Dependent Information Table CPU Dependent Information Table, Processor Dependent Information Table, Processor Dependent Information Table
@end ifinfo
@section Introduction

Any highly processor dependent information required
to describe a processor to RTEMS is provided in the CPU
Dependent Information Table.  This table is not required for all
processors supported by RTEMS.  This chapter describes the
contents, if any, for a particular processor type.

@ifinfo
@node Processor Dependent Information Table CPU Dependent Information Table, Memory Requirements, Processor Dependent Information Table Introduction, Processor Dependent Information Table
@end ifinfo
@section CPU Dependent Information Table

The PowerPC version of the RTEMS CPU Dependent
Information Table is given by the C structure definition is
shown below:

@example
typedef struct @{
  void       (*pretasking_hook)( void );
  void       (*predriver_hook)( void );
  void       (*postdriver_hook)( void );
  void       (*idle_task)( void );
  boolean      do_zero_of_workspace;
  unsigned32   interrupt_stack_size;
  unsigned32   extra_mpci_receive_server_stack;
  void *     (*stack_allocate_hook)( unsigned32 );
  void       (*stack_free_hook)( void* );
  /* end of fields required on all CPUs */

  unsigned32   clicks_per_usec; /* Timer clicks per microsecond */
  void       (*spurious_handler)(unsigned32 vector, CPU_Interrupt_frame *);
  boolean      exceptions_in_RAM;     /* TRUE if in RAM */
  unsigned32   serial_per_sec;  /* Serial clocks per second */
  boolean      serial_external_clock;
  boolean      serial_xon_xoff;
  boolean      serial_cts_rts;
  unsigned32   serial_rate;
  unsigned32   timer_average_overhead; /* Average overhead of timer in ticks */
  unsigned32   timer_least_valid; /* Least valid number from timer */
  void (*spurious_handler)(unsigned32 vector, CPU_Interrupt_frame *);

@};
@end example

@table @code
@item pretasking_hook
is the address of the
user provided routine which is invoked once RTEMS initialization
is complete but before interrupts and tasking are enabled.  This
field may be NULL to indicate that the hook is not utilized.

@item predriver_hook
is the address of the user provided
routine which is invoked with tasking enabled immediately before
the MPCI and device drivers are initialized. RTEMS
initialization is complete, interrupts and tasking are enabled,
but no device drivers are initialized.  This field may be NULL to
indicate that the hook is not utilized.

@item postdriver_hook
is the address of the user provided
routine which is invoked with tasking enabled immediately after
the MPCI and device drivers are initialized. RTEMS
initialization is complete, interrupts and tasking are enabled,
and the device drivers are initialized.  This field may be NULL
to indicate that the hook is not utilized.

@item idle_task
is the address of the optional user
provided routine which is used as the system's IDLE task.  If
this field is not NULL, then the RTEMS default IDLE task is not
used.  This field may be NULL to indicate that the default IDLE
is to be used.

@item do_zero_of_workspace
indicates whether RTEMS should
zero the Workspace as part of its initialization.  If set to
TRUE, the Workspace is zeroed.  Otherwise, it is not.

@item interrupt_stack_size
is the size of the RTEMS allocated interrupt stack in bytes.
This value must be at least as large as MINIMUM_STACK_SIZE.

@item extra_mpci_receive_server_stack
is the extra stack space allocated for the RTEMS MPCI receive server task
in bytes.  The MPCI receive server may invoke nearly all directives and 
may require extra stack space on some targets.

@item stack_allocate_hook
is the address of the optional user provided routine which allocates 
memory for task stacks.  If this hook is not NULL, then a stack_free_hook
must be provided as well.

@item stack_free_hook
is the address of the optional user provided routine which frees 
memory for task stacks.  If this hook is not NULL, then a stack_allocate_hook
must be provided as well.

@item clicks_per_usec
is the number of decrementer interupts that occur each microsecond.

@item spurious_handler
is the address of the
routine which is invoked when a spurious interrupt occurs.

@item exceptions_in_RAM
indicates whether the exception vectors are located in RAM or ROM.  If 
they are located in RAM dynamic vector installation occurs, otherwise
it does not.

@item serial_per_sec
is the number of clock ticks per second for the PPC403 serial timer.

@item serial_rate
is the baud rate for the PPC403 serial timer.

@item serial_external_clock
is a flag used by the BSP to indicate whether or not to mask in a 0x2 into
the Input/Output Configuration Register (IOCR) during initialization of the
PPC403 console.  XXX This bit is defined as "reserved" 6-12?

@item serial_xon_xoff
is a flag used by the BSP to indicate whether or not  XON/XOFF flow control 
is supported for the PPC403 serial timer.

@item serial_cts_rts
is a flag used by the BSP to indicate whether or not to set the lsb of the 
Input/Output Configuration Register (IOCR) during initialization of the
PPC403 console.  XXX This bit is defined as "reserved" 6-12?


@item timer_average_overhead
is the average number of overhead ticks that occur on the PPC403 timer.

@item timer_least_valid
is the maximum valid PPC403 timer value.

@end table

