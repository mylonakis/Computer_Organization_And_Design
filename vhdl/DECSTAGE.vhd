library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECSTAGE is
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
           FR_DataIn : out  STD_LOGIC_VECTOR (31 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end DECSTAGE;

architecture Behavioral of DECSTAGE is

COMPONENT FileRegister is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0):="00000";
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0):="00000";
           Awr : in  STD_LOGIC_VECTOR (4 downto 0):="00000";
			  RESET : in  STD_LOGIC;
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0):= "00000000000000000000000000000000";
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0):= "00000000000000000000000000000000";
           Din : in  STD_LOGIC_VECTOR (31 downto 0):= "00000000000000000000000000000000";
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC);
END COMPONENT;

COMPONENT Mux_2x1_32bit is
	Port (  MuxIn0   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn1   : in  STD_LOGIC_VECTOR(31 downto 0);
           MuxSel : in  STD_LOGIC;
           MuxOut : out STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;

COMPONENT Mux_2x1_5bit is
	Port (  MuxIn0   : in  STD_LOGIC_VECTOR(4 downto 0);
			  MuxIn1   : in  STD_LOGIC_VECTOR(4 downto 0);
           MuxSel : in  STD_LOGIC;
           MuxOut : out STD_LOGIC_VECTOR(4 downto 0));
END COMPONENT Mux_2x1_5bit;

COMPONENT ImmCloud is
		Port ( DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
				 OpCode : in  STD_LOGIC_VECTOR (5 downto 0);
				 ImmExt: in STD_LOGIC;
				 ImmOut : out  STD_LOGIC_VECTOR (31 downto 0));
END COMPONENT ImmCloud;

signal signalMuxOut4bit: STD_LOGIC_VECTOR (4 downto 0);
signal signalMuxOut32bit: STD_LOGIC_VECTOR (31 downto 0);


BEGIN
	FR: FileRegister
	Port Map(
				Ard1 => Instr(25 downto 21),
				Ard2 => signalMuxOut4bit,
				Awr => Rd_in_WB, --changes !!!
				RESET => RF_Reset,
				Dout1 => RF_A,
				Dout2 => RF_B,
				Din => signalMuxOut32bit,
				WrEn => RF_WrEn,
				Clk => Clk	
				);
				
	MUX5bit: Mux_2x1_5bit 
	Port Map(
				MuxIn0 => Instr(15 downto 11),
				MuxIn1 => Instr(20 downto 16),
				MuxSel => RF_B_sel,
				MuxOut => signalMuxOut4bit
			   );
				
	MUX32bit: Mux_2x1_32bit 
	Port Map(
				MuxIn0 => ALU_out,
				MuxIn1 => MEM_out,
				MuxSel => RF_WrData_sel,
				MuxOut => signalMuxOut32bit
			   );
	
	IMMEDIATE: ImmCloud
	Port Map(
				DataIn => Instr(15 downto 0),
				OpCode => Instr(31 downto 26),
				ImmExt => ImmExt,
				ImmOut => Immed
			   );
	
	FR_DataIn <= signalMuxOut32bit; 		
END Behavioral;