library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROCESSOR is
    Port ( Clock : in  STD_LOGIC;
			  Reset : in STD_LOGIC);
end PROCESSOR;

architecture Behavioral of PROCESSOR is

COMPONENT Datapath
PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		RF_WrEn : IN std_logic;
		RF_WrData_sel : IN std_logic;
		RF_B_Sel : IN std_logic;
		ImmExt_s : IN std_logic;
		PC_sel : IN std_logic;
--		PC_LdEn : IN std_logic;
		ALU_RF_A_sel : IN std_logic;
		ALU_Bin_sel : IN std_logic;
		ALU_func : IN std_logic_vector(3 downto 0);
		Mem_WrEn : IN std_logic;
		byteFlagMEM : IN std_logic;
		byteFlagWB : IN std_logic;
--		IFID_WrEn: IN STD_LOGIC;
--		IDEX_WrEn: IN STD_LOGIC;
--		EXMEM_WrEn: IN STD_LOGIC;
--		MEMWB_WrEn: IN STD_LOGIC;       
		Instruction : OUT std_logic_vector(31 downto 0);
		Equal : OUT std_logic
	);
END COMPONENT;

	
	
COMPONENT PipeLineControl
PORT(
		OpCode : in STD_LOGIC_VECTOR(5 downto 0);	
      func : in STD_LOGIC_VECTOR(3 downto 0);
		ZeroIn : IN std_logic;
--		IFID_WrEn : OUT std_logic;
--		IDEX_WrEn : OUT std_logic;
--		EXMEM_WrEn : OUT std_logic;
--		MEMWB_WrEn : OUT std_logic;          
		PC_sel : OUT std_logic;
--		PC_LdEn : OUT std_logic;
		RF_WrEn : OUT std_logic;
		RF_WrData_sel : OUT std_logic;
		RF_B_sel : OUT std_logic;
		ImmExt_s : OUT std_logic;
		ALU_RF_A_sel : OUT std_logic;
		ALU_Bin_sel : OUT std_logic;
		ALU_func : OUT std_logic_vector(3 downto 0);
		byteFlagMEM : OUT std_logic;
		byteFlagWB : OUT std_logic;
		Mem_WrEn : OUT std_logic
	);
END COMPONENT;

--LAB 3
signal signalInstructionProc :  std_logic_vector(31 downto 0);
signal signalEqualProc :  std_logic;          
signal signalPC_selProc :  std_logic;
signal signalRF_WrEnProc :  std_logic;
signal signalRF_WrData_selProc :  std_logic;
signal signalRF_B_selProc :  std_logic;
signal signalALU_Bin_selProc :  std_logic;
signal signalALU_funcProc :  std_logic_vector(3 downto 0);
signal signalMem_WrEnProc :  std_logic;
signal signalImmExt_sProc : std_logic;
signal signal_PC_LdEn : std_logic;
signal signal_ALU_RF_A_sel: std_logic;
signal signal_ImmExt_s: std_logic;
signal signal_byteFlagMEM: std_logic;
signal signal_byteFlagWB: std_logic;
signal signal_IDEX_WrEn: std_logic;
signal signal_EXMEM_WrEn: std_logic;
signal signal_MEMWB_WrEn: std_logic;
signal signal_IFID_WrEn: std_logic;
	
begin

Inst_Datapath: Datapath PORT MAP(
		Clock => Clock,
		Reset => Reset,
		RF_WrEn => signalRF_WrEnProc,
		RF_WrData_sel => signalRF_WrData_selProc,
		RF_B_Sel => signalRF_B_selProc,
		ImmExt_s => signal_ImmExt_s,
		PC_sel => signalPC_selProc,
--		PC_LdEn => signal_PC_LdEn,
		ALU_RF_A_sel => signal_ALU_RF_A_sel,
		ALU_Bin_sel => signalALU_Bin_selProc,
		ALU_func => signalALU_funcProc,
		Mem_WrEn => signalMem_WrEnProc,
		byteFlagMEM => signal_byteFlagMEM,
		byteFlagWB => signal_byteFlagWB,
		Instruction => signalInstructionProc,
		Equal => signalEqualProc
--		IFID_WrEn => signal_IFID_WrEn,
--		IDEX_WrEn => signal_IDEX_WrEn,
--		EXMEM_WrEn => signal_EXMEM_WrEn,
--		MEMWB_WrEn => signal_MEMWB_WrEn
	);
	
	MainControl: PipeLineControl 
	PORT MAP(
		OpCode => signalInstructionProc(31 downto 26),
		func => signalInstructionProc(3 downto 0),
		ZeroIn => signalEqualProc,
		PC_sel => signalPC_selProc,
--		PC_LdEn => signal_PC_LdEn,
		RF_WrEn => signalRF_WrEnProc,
		RF_WrData_sel => signalRF_WrData_selProc,
		RF_B_sel => signalRF_B_selProc,
		ImmExt_s => signal_ImmExt_s,
		ALU_RF_A_sel => signal_ALU_RF_A_sel,
		ALU_Bin_sel => signalALU_Bin_selProc,
		ALU_func => signalALU_funcProc,
		byteFlagMEM => signal_byteFlagMEM,
		byteFlagWB => signal_byteFlagWB,
		Mem_WrEn => signalMem_WrEnProc
--		IFID_WrEn => signal_IFID_WrEn,
--		IDEX_WrEn => signal_IDEX_WrEn,
--		EXMEM_WrEn => signal_EXMEM_WrEn,
--		MEMWB_WrEn => signal_MEMWB_WrEn
	);
end Behavioral;

