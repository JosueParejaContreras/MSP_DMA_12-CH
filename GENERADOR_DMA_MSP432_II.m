clear all;
clc;

ADC_TASKS = 16384+32;    % The number of ADC samples you need 
a = 1;

L{a} = '#define MCLK_FREQUENCY      48000000';a = a+1;
L{a} = '#define SMCLK_FREQUENCY     24000000';a = a+1;
L{a} = ['#define NUMBER_OF_SAMPLES       ' num2str(ADC_TASKS)];a = a+1;
L{a} = '#define CONVERSIONS_PER_SAMPLE  1';a = a+1;
L{a} = '#define ADC_TASKS              (NUMBER_OF_SAMPLES/32)+4';a = a+1;
L{a} = ' ';a = a+1;
L{a} = 'int16_t dataSet_01[NUMBER_OF_SAMPLES][CONVERSIONS_PER_SAMPLE];';a = a+1;

L{a} = 'const uint16_t forceT0 = 0x0201;';a = a+1;
L{a} = 'uint16_t F = 0,FH=1;';a = a+1;
L{a} = 'bool dataSet0Ready;';a = a+1;
L{a} = ' ';a = a+1;
L{a} ='#if defined(__TI_COMPILER_VERSION__)';a = a+1;
L{a} ='#pragma DATA_ALIGN(MSP_EXP432P401RLP_DMAControlTable, 512)';a = a+1;
L{a} ='#elif defined(__IAR_SYSTEMS_ICC__)';a = a+1;
L{a} ='#pragma data_alignment=512';a = a+1;
L{a} ='#elif defined(__GNUC__)';a = a+1;
L{a} ='__attribute__ ((aligned (512)))';a = a+1;
L{a} ='#elif defined(__CC_ARM)';a = a+1;
L{a} ='__align(512)';a = a+1;
L{a} ='#endif';a = a+1;
L{a} ='static DMA_ControlTable MSP_EXP432P401RLP_DMAControlTable[16];  // 8 primary and 8 alternate';a = a+1;
L{a} ='DMA_ControlTable pingTask;';a = a+1;
L{a} ='DMA_ControlTable pongTask;';a = a+1;
L{a} = ' ';a = a+1;
L{a} ='const DMA_ControlTable AdcDmaSeq_01[ADC_TASKS] =';a = a+1;
L{a} ='{';a = a+1;

% Here you must put the path to the CCS project
fid1 = fopen('D:\PROYECTOS2018\PROY_CODE_COM\MSP432_DMASG_DISE_1024\preCompile.h','wt');
for e = 1:a-1
    fprintf(fid1,'%s\n',L{e});
end

for e = 0:((ADC_TASKS/32)-1)/2
    
    DEST = strcat('        UDMA_DST_INC_16, &dataSet_01[',num2str(e*32));
    DEST = strcat(DEST,'][0],');
    fprintf(fid1,'%s\n','DMA_TaskStructEntry(32, UDMA_SIZE_16,');
    fprintf(fid1,'%s\n','        UDMA_SRC_INC_32,(void*)&ADC14->MEM[0],');
    fprintf(fid1,'%s\n',DEST);
    fprintf(fid1,'%s','        UDMA_ARB_32, UDMA_MODE_PER_SCATTER_GATHER),');
    fprintf(fid1,'%s\n',strcat('//',num2str(e)));
end

    fprintf(fid1,'%s\n','DMA_TaskStructEntry(4, UDMA_SIZE_32,');
    fprintf(fid1,'%s\n','            UDMA_SRC_INC_32, (void *)&pongTask,');
    fprintf(fid1,'%s\n','            UDMA_DST_INC_32, (void *)&MSP_EXP432P401RLP_DMAControlTable[7],');
    fprintf(fid1,'%s\n','            UDMA_ARB_4, UDMA_MODE_MEM_SCATTER_GATHER)');
    fprintf(fid1,'%s\n','};');
    
    fprintf(fid1,'\n%s\n','const DMA_ControlTable AdcDmaSeq_02[ADC_TASKS] =');
    fprintf(fid1,'%s\n','{');
    e = (e+1)
    
 % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     
    
for e = e:((ADC_TASKS/32)-1)
    
    DEST = strcat('        UDMA_DST_INC_16, &dataSet_01[',num2str((e)*32));
    DEST = strcat(DEST,'][0],');
    fprintf(fid1,'%s\n','DMA_TaskStructEntry(32, UDMA_SIZE_16,');
    fprintf(fid1,'%s\n','        UDMA_SRC_INC_32,(void*)&ADC14->MEM[0],');
    fprintf(fid1,'%s\n',DEST);
    fprintf(fid1,'%s','        UDMA_ARB_32, UDMA_MODE_PER_SCATTER_GATHER),');
    fprintf(fid1,'%s\n',strcat('//',num2str(e)));
    
end
    fprintf(fid1,'\n%s\n','DMA_TaskStructEntry(1, UDMA_SIZE_16,');
    fprintf(fid1,'%s\n','            UDMA_SRC_INC_16, (void *)&FH,');
    fprintf(fid1,'%s\n','            UDMA_DST_INC_16, (void *)&F,');  
    fprintf(fid1,'%s\n','            UDMA_ARB_1, UDMA_MODE_MEM_SCATTER_GATHER),');

    fprintf(fid1,'\n%s\n','DMA_TaskStructEntry(1, UDMA_SIZE_16,');
    fprintf(fid1,'%s\n','            UDMA_SRC_INC_16, (void *)&forceT0,');
    fprintf(fid1,'%s\n','            UDMA_DST_INC_16, (void *)&TIMER_A0->CTL,');
    fprintf(fid1,'%s\n','            UDMA_ARB_1, UDMA_MODE_MEM_SCATTER_GATHER),');
    
    fprintf(fid1,'%s\n','DMA_TaskStructEntry(4, UDMA_SIZE_32,');
    fprintf(fid1,'%s\n','            UDMA_SRC_INC_32, (void *)&pingTask,');
    fprintf(fid1,'%s\n','            UDMA_DST_INC_32, (void *)&MSP_EXP432P401RLP_DMAControlTable[7],');
    fprintf(fid1,'%s\n','            UDMA_ARB_4, UDMA_MODE_MEM_SCATTER_GATHER)');
    fprintf(fid1,'%s\n','};');
    
fclose(fid1);