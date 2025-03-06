
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IF_ID_REG is
	Port (
			Clock: in  STD_LOGIC;
         Reset: in  STD_LOGIC;
			WrEn: in STD_LOGIC;
			InstrIn: in STD_LOGIC_VECTOR(31 downto 0);
			InstrOut: out STD_LOGIC_VECTOR(31 downto 0)
			);
	
end IF_ID_REG;

architecture Behavioral of IF_ID_REG is

signal temp: STD_LOGIC_VECTOR (31 downto 0);

begin
	
	process(Clock,Reset)
	begin
		if Reset = '1' then
			temp <= "00000000000000000000000000000000";
		elsif (rising_edge(Clock)) then 
			if (WrEn = '1') then 
				temp <= InstrIn;
			end if;
		end if;
	end process;
	
	InstrOut <= temp after 5 ns;

end Behavioral;

