################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Each subdirectory must supply rules for building sources it contributes
bitrev.obj: ../bitrev.sa $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --include_path="C:/ti/C6xCSL/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="bitrev.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

cfftr2_dit.obj: ../cfftr2_dit.sa $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --include_path="C:/ti/C6xCSL/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="cfftr2_dit.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

digitrev_index.obj: ../digitrev_index.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --include_path="C:/ti/C6xCSL/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="digitrev_index.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

lab5_FIR_FxF.obj: ../lab5_FIR_FxF.c $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --include_path="C:/ti/C6xCSL/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="lab5_FIR_FxF.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '

vectors.obj: ../vectors.asm $(GEN_OPTS) $(GEN_SRCS)
	@echo 'Building file: $<'
	@echo 'Invoking: C6000 Compiler'
	"C:/ti/ccsv5/tools/compiler/c6000_7.4.2/bin/cl6x" -mv6713 --abi=coffabi -g --include_path="C:/ti/DSK6713/c6000/dsk6713/include" --include_path="C:/ti/include" --include_path="C:/ti/C6xCSL/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --include_path="C:/ti/ccsv5/tools/compiler/c6000_7.4.2/include" --display_error_number --diag_warning=225 --diag_wrap=off --mem_model:const=far --mem_model:data=far --preproc_with_compile --preproc_dependency="vectors.pp" $(GEN_OPTS__FLAG) "$<"
	@echo 'Finished building: $<'
	@echo ' '


