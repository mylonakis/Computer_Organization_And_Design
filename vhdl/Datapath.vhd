library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Datapath is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  
			  --For DECstage
           RF_WrEn : in  STD_LOGIC;
           RF_WrData_sel : in  STD_LOGIC;
			  RF_B_Sel : in  STD_LOGIC;
           ImmExt_s : in  STD_LOGIC;
			  
			  --For IFstage
           PC_sel : in  STD_LOGIC;
--           PC_LdEn : in  STD_LOGIC;
			  
			  --For ALUstage
			  ALU_RF_A_sel: in STD_LOGIC;
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  
			  --For MEMstage
           Mem_WrEn : in STD_LOGIC;
			  --Need two flags instead of one like previous lab, because 
			  --there is probability to have different instructions in MEM and WB stage at the same time.
			  byteFlagMEM: in STD_LOGIC; --LSByte selector enable in MEMSTAGE for sb instruction
			  byteFlagWB:  in STD_LOGIC;  --LSByte selector enable after MEMSTAGE, at WriteBack stage for lb instruction		 
           --For Control
			  Instruction : out STD_LOGIC_VECTOR (31 downto 0);
			  Equal : out STD_LOGIC
			  
			  --LAB 5
--			  IFID_WrEn: in STD_LOGIC;
--			  IDEX_WrEn: in STD_LOGIC;
--			  EXMEM_WrEn: in STD_LOGIC;
--			  MEMWB_WrEn: in STD_LOGIC
			  );
			  
end Datapath;

architecture Behavioral of Datapath is

COMPONENT DECSTAGE
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
			  RF_Reset : in  STD_LOGIC;
           RF_B_Sel : in  STD_LOGIC;
			  ImmExt: in STD_LOGIC;
           Clk : in  STD_LOGIC;
			  Rd_in_WB: in STD_LOGIC_VECTOR (4 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
			  FR_DataIn : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

COMPONENT ALUSTAGE
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
			  DataToRam : out  STD_LOGIC_VECTOR (31 downto 0); -- lab 5 new Signal
			  ALU_result : in  STD_LOGIC_VECTOR (31 downto 0);--lab 5
           DataIn_WB : in  STD_LOGIC_VECTOR (31 downto 0); --lab 5
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
			  ALU_RF_A_sel: in STD_LOGIC;
           ALU_Bin_sel : in  STD_LOGIC;
           ForwardA : in  STD_LOGIC_VECTOR(1 downto 0);
           ForwardB : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  ZERO : out STD_LOGIC);
END COMPONENT;

COMPONENT IFSTAGE_label
	 Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT;

COMPONENT RAM
	Port( clk       : in std_logic;
			inst_addr : in std_logic_vector(10 downto 0);
         inst_dout : out std_logic_vector(31 downto 0);
         data_we   : in std_logic;
         data_addr : in std_logic_vector(10 downto 0);
         data_din  : in std_logic_vector(31 downto 0);
         data_dout : out std_logic_vector(31 downto 0));
END COMPONENT;

COMPONENT LSB_Selector
PORT(
	byteFlag : IN std_logic;
	DataIn : IN std_logic_vector(31 downto 0);          
	DataOut : OUT std_logic_vector(31 downto 0)
	);
END COMPONENT;

-- LAB 5
COMPONENT IF_ID_REG
PORT (
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn: IN STD_LOGIC;
		InstrIn : IN std_logic_vector(31 downto 0);          
		InstrOut : OUT std_logic_vector(31 downto 0)
		);
END COMPONENT;

COMPONENT ID_EX_REG
PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		RF_A : IN std_logic_vector(31 downto 0);
		RF_B : IN std_logic_vector(31 downto 0);
		Immed : IN std_logic_vector(31 downto 0);
		InstrIn: IN std_logic_vector(31 downto 0);
		InstrOut: OUT std_logic_vector(31 downto 0);
		Rs : IN std_logic_vector(4 downto 0);
		Rd : IN std_logic_vector(4 downto 0);
		Rt : IN std_logic_vector(4 downto 0);
		RF_WrEn_In : IN std_logic;
		RF_WrData_sel_In : IN std_logic;
		byteFlagWB_In : IN std_logic;
		Mem_WrEn_In : IN std_logic;
		ALU_RF_A_sel_In : IN std_logic;
		ALU_Bin_sel_In : IN std_logic;
		ALU_func_In : IN std_logic_vector(3 downto 0);          
		RF_A_out : OUT std_logic_vector(31 downto 0);
		RF_B_out : OUT std_logic_vector(31 downto 0);
		Immed_out : OUT std_logic_vector(31 downto 0);
		Rs_out : OUT std_logic_vector(4 downto 0);
		Rd_out : OUT std_logic_vector(4 downto 0);
		Rt_out : OUT std_logic_vector(4 downto 0);
		RF_WrEn_Out : OUT std_logic;
		RF_WrData_sel_Out : OUT std_logic;
		byteFlagWB_Out : OUT std_logic;
		Mem_WrEn_Out : OUT std_logic;
		ALU_RF_A_sel_Out : OUT std_logic;
		ALU_Bin_sel_Out : OUT std_logic;
		ALU_func_Out : OUT std_logic_vector(3 downto 0);
		byteFlagMEM_In: in STD_LOGIC;
		byteFlagMEM_Out: out STD_LOGIC
		);
END COMPONENT;

COMPONENT EX_MEM_REG
PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		ALU_out : IN std_logic_vector(31 downto 0);
		RF_B_In : IN std_logic_vector(31 downto 0);
		RF_WrEn_In : IN std_logic;
		RF_WrData_sel_In : IN std_logic;
		byteFlagWB_In : IN std_logic;
		Mem_WrEn_In : IN std_logic;
		Rd: in STD_LOGIC_VECTOR(4 downto 0);
		Rd_out: OUT STD_LOGIC_VECTOR(4 downto 0);		
		ALU_out_to_MEM : OUT std_logic_vector(31 downto 0);
		RF_B_Out : OUT std_logic_vector(31 downto 0);
		RF_WrEn_Out : OUT std_logic;
		RF_WrData_sel_Out : OUT std_logic;
		byteFlagWB_Out : OUT std_logic;
		byteFlagMEM_In: in STD_LOGIC;
		byteFlagMEM_Out: out STD_LOGIC;
		Mem_WrEn_Out : OUT std_logic
		);
END COMPONENT;

COMPONENT MEM_WB_REG
PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		MemData_In : IN std_logic_vector(31 downto 0);
		ALU_In : IN std_logic_vector(31 downto 0);
		RF_WrEn_In : IN std_logic;
		RF_WrData_sel_In : IN std_logic;
		byteFlagWB_In : IN std_logic;
		Rd: in STD_LOGIC_VECTOR(4 downto 0);
		Rd_out: out STD_LOGIC_VECTOR(4 downto 0);		
		MemData_Out : OUT std_logic_vector(31 downto 0);
		ALU_Out : OUT std_logic_vector(31 downto 0);
		RF_WrEn_Out : OUT std_logic;
		RF_WrData_sel_Out : OUT std_logic;
		byteFlagWB_Out : OUT std_logic
		);
END COMPONENT;

COMPONENT StallUnit
PORT(
	OpCodeIDEX : IN std_logic_vector(5 downto 0);
	Rs_IFID : IN std_logic_vector(4 downto 0);
	Rt_IFID : IN std_logic_vector(4 downto 0);
	Rt_IDEX : IN std_logic_vector(4 downto 0);          
	Mux_sel : OUT std_logic;
	IFID_WrEn : OUT std_logic;
	Pc_LdEn_Out : OUT std_logic
	);
END COMPONENT;

COMPONENT Mux_Before_IDEX
PORT(
	Sel : IN std_logic;
	DataIn : IN std_logic_vector(10 downto 0);          
	DataOut : OUT std_logic_vector(10 downto 0)
	);
END COMPONENT;

COMPONENT ForwardUnit
PORT(
	RF_WrEn_EXMEM : IN std_logic;
	RF_WrEn_MEMWB : IN std_logic;
	OpCode: in STD_LOGIC_VECTOR(5 downto 0);
	Rd_IDEX: in STD_LOGIC_VECTOR(4 downto 0);
	Rd_EXMEM : IN std_logic_vector(4 downto 0);
	Rs_IDEX : IN std_logic_vector(4 downto 0);
	Rd_MEMWB : IN std_logic_vector(4 downto 0);
	Rt_IDEX : IN std_logic_vector(4 downto 0);          
	ForwardA : OUT std_logic_vector(1 downto 0);
	ForwardB : OUT std_logic_vector(1 downto 0)
	);
END COMPONENT;

--DECSTAGE signals
signal signal_RF_A: STD_LOGIC_VECTOR(31 downto 0);
signal signal_RF_B: STD_LOGIC_VECTOR(31 downto 0);
signal signal_extImmed: STD_LOGIC_VECTOR(31 downto 0);
signal signal_MEM_out_to_DEC: STD_LOGIC_VECTOR(31 downto 0);

--ALUSTAGE signals
signal signal_ALU_out: STD_LOGIC_VECTOR(31 downto 0);

--IFSTAGE signals
signal signal_PC: STD_LOGIC_VECTOR(31 downto 0);

--RAM signals
signal signal_inst_dout: STD_LOGIC_VECTOR(31 downto 0);
signal signal_ALU_out_to_MEM: STD_LOGIC_VECTOR(10 downto 0);
signal signalZero : STD_LOGIC;

signal temp: STD_LOGIC_VECTOR(31 downto 0);

signal signal_DataOut_to_RF: STD_LOGIC_VECTOR(31 downto 0);
signal signal_DataOut_to_MEM: STD_LOGIC_VECTOR(31 downto 0);

-- LAB5
signal signal_inst_dout_IFID: STD_LOGIC_VECTOR(31 downto 0);

signal signal_RF_A_IDEX: STD_LOGIC_VECTOR(31 downto 0);
signal signal_RF_B_IDEX: STD_LOGIC_VECTOR(31 downto 0);
signal signal_Immed_out_IDEX: STD_LOGIC_VECTOR(31 downto 0);
signal signal_Rs_out: STD_LOGIC_VECTOR(4 downto 0);
signal signal_Rd_out: STD_LOGIC_VECTOR(4 downto 0);
signal signal_Rt_out: STD_LOGIC_VECTOR(4 downto 0);
signal signal_RF_WrEn_Out_IDEX: STD_LOGIC;
signal signal_RF_WrData_Sel_Out_IDEX: STD_LOGIC;
signal signal_byteFlagWB_Out_IDEX: STD_LOGIC;
signal signal_Mem_WrEn_Out_IDEX: STD_LOGIC;
signal signal_RF_A_sel_Out_IDEX: STD_LOGIC;
signal signal_Bin_sel_Out_IDEX: STD_LOGIC;
signal signal_byteFlagMEM_out_IDEX: STD_LOGIC;
signal signal_ALU_func_Out_IDEX: STD_LOGIC_VECTOR(3 downto 0);

signal signal_ALU_out_to_MEM_OUT_EXMEM: STD_LOGIC_VECTOR(31 downto 0);
signal signal_RF_B_Out_EXMEM: STD_LOGIC_VECTOR(31 downto 0);
signal signal_byteFlagMEM_out_EXMEM: STD_LOGIC;
signal signal_Mem_WrEn_Out_EXMEM: STD_LOGIC;
signal signal_RF_WrEn_Out_EXMEM: STD_LOGIC;
signal signal_RF_WrData_Sel_Out_EXMEM: STD_LOGIC;

signal signal_MEMData_Out_WB: STD_LOGIC_VECTOR(31 downto 0);
signal signal_ALU_Out_WB: STD_LOGIC_VECTOR(31 downto 0);
signal signal_RF_WrEn_Out_WB: STD_LOGIC;
signal signal_RF_WrData_sel_Out_WB: STD_LOGIC;
signal signal_byteFlagWB_Out_WB: STD_LOGIC;
signal signal_byteFlagWB_Out_EXMEM: STD_LOGIC;

signal signal_Rd_out_EXMEM: STD_LOGIC_VECTOR(4 downto 0);
signal signal_Rd_out_MEMWB: STD_LOGIC_VECTOR(4 downto 0);

signal signal_PC_LdEn: STD_LOGIC;
signal signal_WrEn_IFID: STD_LOGIC;
signal signal_Mux_sel: STD_LOGIC;

signal signalForwardA: STD_LOGIC_VECTOR(1 downto 0);
signal signalForwardB: STD_LOGIC_VECTOR(1 downto 0);

signal signal_InstrOut_IDEX: STD_LOGIC_VECTOR(31 downto 0);

signal signa_FR_DataIn: STD_LOGIC_VECTOR(31 downto 0);

signal signal_ALUSTAGE_DataToRam: STD_LOGIC_VECTOR(31 downto 0);

signal signalDataOut_to_IDEX: STD_LOGIC_VECTOR(10 downto 0);


begin


	DECSTAGE_Instance: DECSTAGE
	PORT MAP (
					Instr => signal_inst_dout_IFID,  --Changes
					RF_WrEn => signal_RF_WrEn_Out_WB, --Changes
					ALU_out => signal_ALU_Out_WB,         --Changes
 					MEM_out => signal_DataOut_to_RF, --Changes
					RF_WrData_sel => signal_RF_WrData_sel_Out_WB, --Changes
					RF_Reset => Reset,
					RF_B_Sel => RF_B_Sel,  
					ImmExt => ImmExt_s,
					Clk => Clock,
					Rd_in_WB => signal_Rd_out_MEMWB, -- New signal 
					FR_DataIn => signa_FR_DataIn, -- New for lab5
					Immed => signal_extImmed,
					RF_A => signal_RF_A,
					RF_B => signal_RF_B
				);
	
	ALUSTAGE_Instance: ALUSTAGE
	PORT MAP (
					RF_A => signal_RF_A_IDEX,
					RF_B => signal_RF_B_IDEX,
					Immed => signal_Immed_out_IDEX,
					DataToRam => signal_ALUSTAGE_DataToRam,
					ALU_Bin_sel => signal_Bin_sel_Out_IDEX,
					ALU_RF_A_sel => signal_RF_A_sel_Out_IDEX,
					ALU_func => signal_ALU_func_Out_IDEX,
					ALU_out => signal_ALU_out,
					Zero => signalZero,
					ALU_result => signal_ALU_out_to_MEM_OUT_EXMEM,
               DataIn_WB => signa_FR_DataIn,
					ForwardA => signalForwardA, 
               ForwardB => signalForwardB
				);
				
	IFSTAGE_Instance: IFSTAGE_label
	PORT MAP (
					PC_Immed => signal_extImmed,
					PC_sel => PC_sel,
					PC_LdEn => signal_PC_LdEn,
					Reset => Reset,
					Clk => Clock,
					PC => signal_PC
				);
				
	p:process(signal_ALU_out_to_MEM_OUT_EXMEM,temp)
	Begin
		temp <= signal_ALU_out_to_MEM_OUT_EXMEM + X"400";
		signal_ALU_out_to_MEM <= temp(10 downto 0);
	End process;
	
	RAM_Instance: RAM
	PORT MAP (
					clk => Clock,
					inst_addr => signal_PC(12 downto 2),
					inst_dout => signal_inst_dout,
					data_we => signal_Mem_WrEn_Out_EXMEM,
					data_addr => signal_ALU_out_to_MEM,
					data_din => signal_DataOut_to_MEM,
					data_dout => signal_MEM_out_to_DEC
				);
	
	Inst_LSB_Selector_MEM_to_RF: LSB_Selector 
	PORT MAP(
		byteFlag => signal_byteFlagWB_Out_WB, --Changes !!!! Important
		DataIn => signal_MEMData_Out_WB,  --signal_MEMData_Out_WB signal_MEM_out_to_DEC
		DataOut => signal_DataOut_to_RF
	);

	Inst_LSB_Selector_RF_to_MEM: LSB_Selector 
	PORT MAP(
		byteFlag => signal_byteFlagMEM_out_EXMEM, --Changes !!!! Important
		DataIn => signal_RF_B_Out_EXMEM,
		DataOut => signal_DataOut_to_MEM
	);	
				
	Instruction <= signal_inst_dout_IFID; -- LAB 5 Changes. Instruction output for data path goes to controller after IFID register.
	Equal <= signalZero;
	
	--LAB 5
	IF_ID: IF_ID_REG -- Double checked. I think is correct
	PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => signal_WrEn_IFID,
		InstrIn => signal_inst_dout, -- from Ram 
		InstrOut => signal_inst_dout_IFID -- to DECSTAGE and also as an output for datapath to connect it with controller
	);
	
	Mux_to_IDEX: Mux_Before_IDEX 
	PORT MAP(
		Sel => '0',
		DataIn(10) => RF_WrEn,
		DataIn(9) => RF_WrData_sel,
		DataIn(8) => byteFlagWB,
		DataIn(7) => ALU_RF_A_sel,
		DataIn(6) => ALU_Bin_sel,
		DataIn(5 downto 2) => ALU_func,
		DataIn(1) => Mem_WrEn,
		DataIn(0) => byteFlagMEM,
		DataOut => signalDataOut_to_IDEX
	);
	
	ID_EX: ID_EX_REG 
	PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => '1',
		RF_A => signal_RF_A,
		RF_B => signal_RF_B,
		Immed => signal_extImmed,
		Rs => signal_inst_dout_IFID(25 downto 21),
		Rd => signal_inst_dout_IFID(20 downto 16),
		Rt => signal_inst_dout_IFID(15 downto 11),		
		RF_A_out => signal_RF_A_IDEX,
		RF_B_out => signal_RF_B_IDEX,
		Immed_out => signal_Immed_out_IDEX,
		Rs_out => signal_Rs_out,
		Rd_out => signal_Rd_out,
		Rt_out => signal_Rt_out,
		RF_WrEn_In => signalDataOut_to_IDEX(10),
		RF_WrData_sel_In => signalDataOut_to_IDEX(9),
		RF_WrEn_Out => signal_RF_WrEn_Out_IDEX,
		RF_WrData_sel_Out => signal_RF_WrData_Sel_Out_IDEX,
		Mem_WrEn_In => signalDataOut_to_IDEX(1),
		Mem_WrEn_Out => signal_Mem_WrEn_Out_IDEX,
		ALU_RF_A_sel_In => signalDataOut_to_IDEX(7),
		ALU_Bin_sel_In => signalDataOut_to_IDEX(6),
		ALU_func_In => signalDataOut_to_IDEX(5 downto 2),
		ALU_RF_A_sel_Out => signal_RF_A_sel_Out_IDEX,
		ALU_Bin_sel_Out => signal_Bin_sel_Out_IDEX,
		ALU_func_Out => signal_ALU_func_Out_IDEX,
		byteFlagWB_In => signalDataOut_to_IDEX(8),
		byteFlagWB_Out => signal_byteFlagWB_Out_IDEX,
		byteFlagMEM_In => signalDataOut_to_IDEX(0),
		byteFlagMEM_Out => signal_byteFlagMEM_out_IDEX,
		InstrIn => signal_inst_dout_IFID,
		InstrOut => signal_InstrOut_IDEX
	);
	
	EX_MEM: EX_MEM_REG 
	PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => '1',
		ALU_out => signal_ALU_out,
		RF_B_In => signal_ALUSTAGE_DataToRam, -- this signal will lead to ram data input
		ALU_out_to_MEM => signal_ALU_out_to_MEM_OUT_EXMEM,
		RF_B_Out => signal_RF_B_Out_EXMEM,
		RF_WrEn_In => signal_RF_WrEn_Out_IDEX,
		RF_WrData_sel_In => signal_RF_WrData_Sel_Out_IDEX,
		RF_WrEn_Out => signal_RF_WrEn_Out_EXMEM,
		RF_WrData_sel_Out => signal_RF_WrData_Sel_Out_EXMEM,
		Mem_WrEn_In => signal_Mem_WrEn_Out_IDEX,
		Mem_WrEn_Out => signal_Mem_WrEn_Out_EXMEM,
		byteFlagWB_In => signal_byteFlagWB_Out_IDEX,
		byteFlagWB_Out => signal_byteFlagWB_Out_EXMEM,
		byteFlagMEM_In => signal_byteFlagMEM_out_IDEX,
		byteFlagMEM_Out => signal_byteFlagMEM_out_EXMEM,
		Rd => signal_Rd_out,
		Rd_out => signal_Rd_out_EXMEM
	);
	
	MEM_WB: MEM_WB_REG PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => '1',
		MemData_In => signal_MEM_out_to_DEC, --signal_MEM_out_to_DEC  signal_MEM_out_to_DEC
		ALU_In => signal_ALU_out_to_MEM_OUT_EXMEM,
		MemData_Out => signal_MEMData_Out_WB,
		ALU_Out => signal_ALU_Out_WB,
		RF_WrEn_In => signal_RF_WrEn_Out_EXMEM,
		RF_WrData_sel_In => signal_RF_WrData_Sel_Out_IDEX,
		byteFlagWB_In => signal_byteFlagWB_Out_EXMEM,
		RF_WrEn_Out => signal_RF_WrEn_Out_WB,
		RF_WrData_sel_Out => signal_RF_WrData_sel_Out_WB,
		byteFlagWB_Out => signal_byteFlagWB_Out_WB,
		Rd => signal_Rd_out_EXMEM,
		Rd_out => signal_Rd_out_MEMWB
	);
	
	Inst_ForwardUnit: ForwardUnit 
	PORT MAP(
		RF_WrEn_EXMEM => signal_RF_WrEn_Out_EXMEM,
		RF_WrEn_MEMWB => signal_RF_WrEn_Out_WB,
		OpCode => signal_InstrOut_IDEX(31 downto 26),
		Rd_IDEX => signal_Rd_out,
		Rd_EXMEM => signal_Rd_out_EXMEM,
		Rs_IDEX => signal_Rs_out,
		Rd_MEMWB => signal_Rd_out_MEMWB,
		Rt_IDEX => signal_Rt_out,
		ForwardA => signalForwardA,
		ForwardB => signalForwardB
	);
	
	Inst_StallUnit: StallUnit 
	PORT MAP(
		OpCodeIDEX => signal_InstrOut_IDEX(31 downto 26),
		Rs_IFID => signal_inst_dout_IFID(25 downto 21),
		Rt_IFID => signal_inst_dout_IFID(15 downto 11),
		Rt_IDEX => signal_Rt_out,
		Mux_sel => signal_Mux_sel,
		IFID_WrEn => signal_WrEn_IFID,
		Pc_LdEn_Out => signal_PC_LdEn
	);
	
end Behavioral;

