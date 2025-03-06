library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ID_EX_REG is
	Port (
			Clock: in  STD_LOGIC;
         Reset: in  STD_LOGIC;
			WrEn:  in STD_LOGIC;
			
			RF_A:  in STD_LOGIC_VECTOR(31 downto 0);
			RF_B:  in STD_LOGIC_VECTOR(31 downto 0);
			Immed:  in STD_LOGIC_VECTOR(31 downto 0);
			Rs:  in STD_LOGIC_VECTOR(4 downto 0);
			Rd:  in STD_LOGIC_VECTOR(4 downto 0);
			Rt:  in STD_LOGIC_VECTOR(4 downto 0);
			InstrIn:  in STD_LOGIC_VECTOR(31 downto 0);
			
			RF_A_out: out STD_LOGIC_VECTOR(31 downto 0);
			RF_B_out: out STD_LOGIC_VECTOR(31 downto 0);
			Immed_out: out STD_LOGIC_VECTOR(31 downto 0);
			Rs_out:  out STD_LOGIC_VECTOR(4 downto 0);
			Rd_out:  out STD_LOGIC_VECTOR(4 downto 0); -- also to WB stage to sychronize awr with dataIn to RF
			Rt_out:  out STD_LOGIC_VECTOR(4 downto 0);
			InstrOut:  out STD_LOGIC_VECTOR(31 downto 0);
			
			--From Control
			
			--WB
			RF_WrEn_In: in STD_LOGIC;
			RF_WrData_sel_In: in STD_LOGIC;
			byteFlagWB_In: in STD_LOGIC;
			RF_WrEn_Out: out STD_LOGIC;
			RF_WrData_sel_Out: out STD_LOGIC;
			byteFlagWB_Out: out STD_LOGIC;
			
			--MEM
			Mem_WrEn_In: in STD_LOGIC;
			byteFlagMEM_In: in STD_LOGIC;
			byteFlagMEM_Out: out STD_LOGIC;
			Mem_WrEn_Out: out STD_LOGIC;
			
			--EXEC
			ALU_RF_A_sel_In : in  STD_LOGIC;
			ALU_Bin_sel_In : in  STD_LOGIC;
			ALU_func_In : in  STD_LOGIC_VECTOR (3 downto 0);
			ALU_RF_A_sel_Out : out  STD_LOGIC;
			ALU_Bin_sel_Out : out  STD_LOGIC;
			ALU_func_Out : out  STD_LOGIC_VECTOR (3 downto 0)
			);
end ID_EX_REG;

architecture Behavioral of ID_EX_REG is

COMPONENT Register_Reset
	PORT(
		CLK : IN std_logic;
		WE : IN std_logic;
		RESET : IN std_logic;
		Data : IN std_logic_vector(31 downto 0);          
		Dout : OUT std_logic_vector(31 downto 0)
		);
END COMPONENT;

COMPONENT Register_5bit
	PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		Data : IN std_logic_vector(4 downto 0);          
		Dout : OUT std_logic_vector(4 downto 0)
		);
END COMPONENT;

COMPONENT WB_REG
	PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		DataIn : IN std_logic_vector(2 downto 0);          
		DataOut : OUT std_logic_vector(2 downto 0)
		);
END COMPONENT;

COMPONENT MEM_REG
	PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		DataIn : IN std_logic_vector(1 downto 0);          
		DataOut : OUT std_logic_vector(1 downto 0)
		);
END COMPONENT;

COMPONENT EX_REG
	PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		DataIn : IN std_logic_vector(5 downto 0);          
		DataOut : OUT std_logic_vector(5 downto 0)
		);
END COMPONENT;

begin

	Instr_REG: Register_Reset 
	PORT MAP(
			CLK => Clock,
			WE => WrEn,
			RESET => Reset,
			Data => InstrIn,
			Dout => InstrOut 
	);

	RF_A_REG: Register_Reset 
	PORT MAP(
			CLK => Clock,
			WE => WrEn,
			RESET => Reset,
			Data => RF_A,
			Dout => RF_A_out 
	);
	
	RF_B_REG: Register_Reset 
	PORT MAP(
			CLK => Clock,
			WE => WrEn,
			RESET => Reset,
			Data => RF_B,
			Dout => RF_B_out 
	);

	Immed_REG: Register_Reset 
	PORT MAP(
			CLK => Clock,
			WE => WrEn,
			RESET => Reset,
			Data => Immed,
			Dout => Immed_out
	);
	
	Rs_REG: Register_5bit 
	PORT MAP(
			Clock => Clock,
			Reset => Reset,
			WrEn => WrEn,
			Data => Rs,
			Dout => Rs_out
	);
	
	Rd_REG: Register_5bit 
	PORT MAP(
			Clock => Clock,
			Reset => Reset,
			WrEn => WrEn,
			Data => Rd,
			Dout => Rd_out
	);
	
	Rt_REG: Register_5bit 
	PORT MAP(
			Clock => Clock,
			Reset => Reset,
			WrEn => WrEn,
			Data => Rt,
			Dout => Rt_out
	);
	
	WB: WB_REG 
	PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => WrEn,
		DataIn(0) => RF_WrEn_In,
		DataIn(1) => RF_WrData_sel_In,
		DataIn(2) => byteFlagWB_In,
		DataOut(0) => RF_WrEn_Out,
		DataOut(1) => RF_WrData_sel_Out,
		DataOut(2) => byteFlagWB_Out
	);
	
	M: MEM_REG 
	PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => WrEn,
		DataIn(0) => Mem_WrEn_In,
		DataIn(1) => byteFlagMEM_In,
		DataOut(0) => Mem_WrEn_Out, 
		DataOut(1) => byteFlagMEM_Out 
	);
	
	EX: EX_REG 
	PORT MAP(
		Clock => Clock,
		Reset => Reset,
		WrEn => WrEn,
		DataIn(0) => ALU_RF_A_sel_In,
		DataIn(1) => ALU_Bin_sel_In,
		DataIn(5 downto 2) => ALU_func_In,
		DataOut(0) => ALU_RF_A_sel_Out,
		DataOut(1) => ALU_Bin_sel_Out,
		DataOut(5 downto 2) => ALU_func_Out
	);
	
end Behavioral;

