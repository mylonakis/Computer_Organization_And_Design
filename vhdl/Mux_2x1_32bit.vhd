library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2x1_32bit is
	Port (  MuxIn0   : in  STD_LOGIC_VECTOR(31 downto 0);
			  MuxIn1   : in  STD_LOGIC_VECTOR(31 downto 0);
           MuxSel : in  STD_LOGIC;
           MuxOut : out STD_LOGIC_VECTOR(31 downto 0));
end Mux_2x1_32bit;



architecture Behavioral of Mux_2x1_32bit is

signal temp: STD_LOGIC_VECTOR(31 downto 0);	

begin

	process(MuxSel,MuxIn0,MuxIn1)
	begin
		case MuxSel is
			when '0' => temp <= MuxIn0;
			when '1' => temp <= MuxIn1;
			when others => null;
		end case;
	end process;
	
	MuxOut <= temp after 5 ns;


end Behavioral;

