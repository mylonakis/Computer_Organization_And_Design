library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity FileRegister is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
			  RESET: in STD_LOGIC;
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC);
end FileRegister;

architecture Structural of FileRegister is


COMPONENT Decoder is

	Port( DecIn : in  STD_LOGIC_VECTOR (4 downto 0);
         DecOut : out  STD_LOGIC_VECTOR (31 downto 0));

END COMPONENT;

COMPONENT Mux_32x1 is
	
	Port(   MuxIn0 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn1 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn2 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn3 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn4 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn5 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn6 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn7 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn8 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn9 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn10 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn11 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn12 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn13 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn14 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn15 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn16 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn17 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn18 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn19 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn20 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn21 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn22 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn23 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn24 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn25 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn26 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn27 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn28 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn29 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn30 : in  STD_LOGIC_VECTOR (31 downto 0);
			  MuxIn31 : in  STD_LOGIC_VECTOR (31 downto 0);
           MuxSel : in   STD_LOGIC_VECTOR  (4 downto 0);
           MuxOut : out  STD_LOGIC_VECTOR (31 downto 0));
			
END COMPONENT;

COMPONENT Register_Reset is

	Port( CLK : in  STD_LOGIC;
         WE : in  STD_LOGIC;
			RESET : in  STD_LOGIC;
         Data : in  STD_LOGIC_VECTOR (31 downto 0);
         Dout : out  STD_LOGIC_VECTOR (31 downto 0));
			
END COMPONENT;

signal decSignalOut: STD_LOGIC_VECTOR (31 downto 0);
signal weSignal: STD_LOGIC_VECTOR (31 downto 0); --The out of 32 logic gates 'AND'
--signal regSignalOut: STD_LOGIC_VECTOR (31 downto 0);
type RegisterArray is array (0 to 31) of std_logic_vector(31 downto 0);
signal DataOutSignal : RegisterArray;
signal muxOutSignal1: STD_LOGIC_VECTOR (31 downto 0);
signal muxOutSignal2: STD_LOGIC_VECTOR (31 downto 0);
--signal AwrSignal : STD_LOGIC_VECTOR (4 downto 0); 
signal i : integer := 0;
--signal j : integer := 0;

begin
Dout1 <= muxOutSignal1;
Dout2 <= muxOutSignal2;

	DEC:Decoder
	PORT MAP
		(
			DecIn => Awr,
			DecOut => decSignalOut
		);
	
	REG0:Register_Reset
	PORT MAP
		(
			CLK => Clk,
			WE => '1',
			RESET => '0',
			Data => "00000000000000000000000000000000",
			Dout => DataOutSignal(0)
		);
	
	Generate_31_Registers: 
	for i in 1 to 31 generate
		weSignal(i) <= (decSignalOut(i) AND WrEn) after 2 ns;	
		
		REGX:Register_Reset
		PORT MAP
			(
				CLK => Clk,
				WE => weSignal(i),
				RESET => RESET,
				Data => Din,
				Dout => DataOutSignal(i)
			);
	end generate Generate_31_Registers;
	
	MUX1: Mux_32x1
	PORT MAP
		(
			MuxIn0 => DataOutSignal(0),
			MuxIn1 => DataOutSignal(1),
			MuxIn2 => DataOutSignal(2),
			MuxIn3 => DataOutSignal(3),
			MuxIn4 => DataOutSignal(4),
			MuxIn5 => DataOutSignal(5),
			MuxIn6 => DataOutSignal(6),
			MuxIn7 => DataOutSignal(7),
			MuxIn8 => DataOutSignal(8),
			MuxIn9 => DataOutSignal(9),
			MuxIn10 => DataOutSignal(10),
			MuxIn11 => DataOutSignal(11),
			MuxIn12 => DataOutSignal(12),
			MuxIn13 => DataOutSignal(13),
			MuxIn14 => DataOutSignal(14),
			MuxIn15 => DataOutSignal(15),
			MuxIn16 => DataOutSignal(16),
			MuxIn17 => DataOutSignal(17),
			MuxIn18 => DataOutSignal(18),
			MuxIn19 => DataOutSignal(19),
			MuxIn20 => DataOutSignal(20),
			MuxIn21 => DataOutSignal(21),
			MuxIn22 => DataOutSignal(22),
			MuxIn23 => DataOutSignal(23),
			MuxIn24 => DataOutSignal(24),
			MuxIn25 => DataOutSignal(25),
			MuxIn26 => DataOutSignal(26),
			MuxIn27 => DataOutSignal(27),
			MuxIn28 => DataOutSignal(28),
			MuxIn29 => DataOutSignal(29),
			MuxIn30 => DataOutSignal(30),
			MuxIn31 => DataOutSignal(31),
			MuxSel => Ard1,
			MuxOut => muxOutSignal1
		);
		
		
	MUX2: Mux_32x1
	PORT MAP
		(
			MuxIn0 => DataOutSignal(0),
			MuxIn1 => DataOutSignal(1),
			MuxIn2 => DataOutSignal(2),
			MuxIn3 => DataOutSignal(3),
			MuxIn4 => DataOutSignal(4),
			MuxIn5 => DataOutSignal(5),
			MuxIn6 => DataOutSignal(6),
			MuxIn7 => DataOutSignal(7),
			MuxIn8 => DataOutSignal(8),
			MuxIn9 => DataOutSignal(9),
			MuxIn10 => DataOutSignal(10),
			MuxIn11 => DataOutSignal(11),
			MuxIn12 => DataOutSignal(12),
			MuxIn13 => DataOutSignal(13),
			MuxIn14 => DataOutSignal(14),
			MuxIn15 => DataOutSignal(15),
			MuxIn16 => DataOutSignal(16),
			MuxIn17 => DataOutSignal(17),
			MuxIn18 => DataOutSignal(18),
			MuxIn19 => DataOutSignal(19),
			MuxIn20 => DataOutSignal(20),
			MuxIn21 => DataOutSignal(21),
			MuxIn22 => DataOutSignal(22),
			MuxIn23 => DataOutSignal(23),
			MuxIn24 => DataOutSignal(24),
			MuxIn25 => DataOutSignal(25),
			MuxIn26 => DataOutSignal(26),
			MuxIn27 => DataOutSignal(27),
			MuxIn28 => DataOutSignal(28),
			MuxIn29 => DataOutSignal(29),
			MuxIn30 => DataOutSignal(30),
			MuxIn31 => DataOutSignal(31),
			MuxSel => Ard2,
			MuxOut => muxOutSignal2
		);
end Structural;