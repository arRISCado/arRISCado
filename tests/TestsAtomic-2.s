# Example by “TheRISC-VInstructionSetManual,VolumeI:User-LevelISA,DocumentVersion 2.2”,EditorsAndrewWatermanandKrsteAsanovi´ c,RISC-VFoundation,May2017    

    # a0 holds address of memory location
    # a1 holds expected value 
    # a2 holds desired value
    # a0 holds return value, 0 if successful, !0 otherwise
cas:
    lr.w t0, (a0)       # Load original value. 
    bne t0, a1, fail    # Doesn’t match, so fail. 
    sc.w a0, a2, (a0)   # Try to update. 
    jr ra               # Return. 
fail: 
    li a0, 1            # Set return to failure. 
    jr ra               # Return.
    