#!/usr/bin/zsh

typeset cols=(
	PID  # "Process ID"
	PPID # "Parent Process ID"
	TID  # "Thread ID"
	NAME
	# TTY     # "Controlling terminal"
	# UID     # "User id"
	USER    # "User name"
	
	TIME # "CPU time consumed"
	SCH  # "Scheduling policy (0=other, 1=fifo, 2=rr, 3=batch, 4=iso, 5=idle)"
	%CPU   # "Percentage of CPU time used"
	# 
	 
	# S       # "Process state: (R) running (S) sleeping (D) device I/O (T) stopped (t) trace stop (X) dead (Z) zombie (P) parked (I) idle (x) dead (K) wakekill (W) waking"
	# STAT    # "Process state+: (<) high priority (N) low priority (L) locked memory (s) session leader (+) foreground (l) multithreaded "
	# RTPRIO  # "Realtime priority"
	# TIME    # "CPU time consumed"
	# TIMEP   # "CPU time (high precision)"
	# ELAPSED # "Elapsed time since PID start"
	# CPU     # "Which processor running on"
	# PSR     # "Processor last executed on"
	# C       # "Total %CPU used since start"
	# %CPU   # "Percentage of CPU time used"
	# MEM_P   # "RSS as % of physical memory"
	# VSZ_P   # "VSZ as % of physical memory"
	# VSZ     # "Virtual memory size (1k units)"
	# RSS     # "Resident Set Size (DRAM pages)"
	# SWAP    # "Swap I/O"
	# BIT     # "32 or 64"
	# DREAD   # "Data read from disk"
	# VIRT    # "Virtual memory size"
	# GID     # "Group ID"
	# PGID    # "Process Group ID"
	# MAJFL   # "Major page faults"
	# MINFL   # "Minor page faults"
	# NI      # "Niceness (static 19 to -20)"
	# PPID    # "Parent Process ID"
	# PRI     # "Priority (dynamic 0 to 139)"
	# IO      # "Data I/O"
	# DIO     # "Disk I/O"
	# READ    # "Data read"
	# WRITE   # "Data written"
	# DWRITE  # "Data written to disk"
	# RGID    # "Real (before sgid) Group ID"
	# RUID    # "Real (before suid) user ID"
	# SHR     # "Shared memory"
	# TCNT    # "Thread count"
	# ADDR    # "Instruction pointer"
	# F       # "Flags 1=FORKNOEXEC 4=SUPERPRIV"
	# GROUP   # "Group name"
	# PCY     # "Android scheduling policy"
	# PR      # "Prio Reversed (dyn 39-0, RT)"
	# RGROUP  # "Real (before sgid) group name"
	# RUSER   # "Real (before suid) user name"
	# SZ      # "4k pages to swap out"
	LABEL   # "Security label"
	WCHAN   # "Wait location in kernel"
	
)


adb shell ps -Awf -o ${(kj:,:)cols} |
	column -i1 -p2 -r4 |
	cat
