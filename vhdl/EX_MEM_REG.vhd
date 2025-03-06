
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity EX_MEM_REG is
Port ( 	
			Clock: in STD_LOGIC;
			Reset: in STD_LOGIC;
			WrEn: in STD_LOGIC;
			ALU_out: in STD_LOGIC_VECTOR(31 downto 0);
			RF_B_In: in STD_LOGIC_VECTOR(31 downto 0);
			ALU_out_to_MEM: out STD_LOGIC_VECTOR(31 downto 0);
			RF_B_Out: out STD_LOGIC_VECTOR(31 downto 0);
			Rd: in STD_LOGIC_VECTOR(4 downto 0);
			Rd_out: out STD_LOGIC_VECTOR(4 downto 0);
			
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
			Mem_WrEn_Out: out STD_LOGIC
		);
end EX_MEM_REG;

architecture Behavioral of EX_MEM_REG is

COMPONENT Register_5bit
	PORT(
		Clock : IN std_logic;
		Reset : IN std_logic;
		WrEn : IN std_logic;
		Data : IN std_logic_vector(4 downto 0);          
		Dout : OUT std_logic_vector(4 downto 0)
		);
END COMPONENT;

COMPONENT Register_Reset
	PORT(
		CLK : IN std_logic;
		WE : IN std_logic;
		RESET : IN std_logic;
		Data : IN std_logic_vector(31 downto 0);          
		Dout : OUT std_logic_vector(31 downto 0)
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


begin

	RF_B_REG_EX: Register_Reset 
	PORT MAP(
			CLK => Clock,
			WE => WrEn,
			RESET => Reset,
			Data => RF_B_In,
			Dout => RF_B_Out
	);
	
	ALU_out_REG: Register_Reset 
	PORT MAP(
			CLK => Clock,
			WE => WrEn,
			RESET => Reset,
			Data => ALU_out,
			Dout => ALU_out_to_MEM
	);
	
	Rd_REG: Register_5bit 
	PORT MAP(
			Clock => Clock,
			Reset => Reset,
			WrEn => WrEn,
			Data => Rd,
			Dout => Rd_out
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

end Behavioral;