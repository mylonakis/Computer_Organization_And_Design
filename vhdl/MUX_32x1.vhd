library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mux_32x1 is
	Port (  MuxIn0   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn1   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn2   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn3   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn4   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn5   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn6   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn7   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn8   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn9   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn10  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn11  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn12  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn13  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn14  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn15  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn16  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn17  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn18  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn19  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn20  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn21  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn22  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn23  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn24  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn25  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn26  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn27  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn28  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn29  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn30  : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn31  : in  STD_LOGIC_VECTOR(31 downto 0);
           MuxSel : in  STD_LOGIC_VECTOR (4 downto 0);
           MuxOut : out STD_LOGIC_VECTOR(31 downto 0));
end Mux_32x1;

architecture Behavioral of Mux_32x1 is

signal temp: STD_LOGIC_VECTOR(31 downto 0);

begin
	
	process(MuxSel,MuxIn0,MuxIn1,MuxIn2,MuxIn3,MuxIn4,MuxIn5,MuxIn6,MuxIn7,MuxIn8,MuxIn9,MuxIn10,MuxIn11,MuxIn12,MuxIn13,MuxIn14,MuxIn15,MuxIn16,
						MuxIn17,MuxIn18,MuxIn19,MuxIn20,MuxIn21,MuxIn22,MuxIn23,MuxIn24,MuxIn25,MuxIn26,MuxIn27,MuxIn28,MuxIn29,MuxIn30,MuxIn31)
	begin
		case MuxSel is
			when "00000" => temp <= MuxIn0;
			when "00001" => temp <= MuxIn1;
			when "00010" => temp <= MuxIn2;
			when "00011" => temp <= MuxIn3;
			when "00100" => temp <= MuxIn4;
			when "00101" => temp <= MuxIn5;
			when "00110" => temp <= MuxIn6;
			when "00111" => temp <= MuxIn7;
			when "01000" => temp <= MuxIn8;
			when "01001" => temp <= MuxIn9;
			when "01010" => temp <= MuxIn10;
			when "01011" => temp <= MuxIn11;
			when "01100" => temp <= MuxIn12;
			when "01101" => temp <= MuxIn13;
			when "01110" => temp <= MuxIn14;
			when "01111" => temp <= MuxIn15;
			when "10000" => temp <= MuxIn16;
			when "10001" => temp <= MuxIn17;
			when "10010" => temp <= MuxIn18;
			when "10011" => temp <= MuxIn19;
			when "10100" => temp <= MuxIn20;
			when "10101" => temp <= MuxIn21;
			when "10110" => temp <= MuxIn22;
			when "10111" => temp <= MuxIn23;
			when "11000" => temp <= MuxIn24;
			when "11001" => temp <= MuxIn25;
			when "11010" => temp <= MuxIn26;
			when "11011" => temp <= MuxIn27;
			when "11100" => temp <= MuxIn28;
			when "11101" => temp <= MuxIn29;
			when "11110" => temp <= MuxIn30;
			when "11111" => temp <= MuxIn31;
			when others => null;
		end case;
	end process;
	
	MuxOut <= temp after 5 ns;
	
end Behavioral;