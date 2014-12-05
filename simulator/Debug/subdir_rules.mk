################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
iir_single.obj: ../iir_single.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="iir_single.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

stereoloop.obj: ../stereoloop.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="stereoloop.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


