library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_REG is
    Port ( Clock : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           WrEn : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR(1 downto 0);
           DataOut : out  STD_LOGIC_VECTOR(1 downto 0));
end MEM_REG;

architecture Behavioral of MEM_REG is

signal temp: STD_LOGIC_VECTOR(1 downto 0);

begin

process(Clock,Reset)
	begin
		IF Reset = '1' THEN
			temp <= "00";
		ELSIF rising_edge(Clock) THEN
			IF WrEn='1' THEN temp <= DataIn;
			END IF;
		END IF;
	end process;
	
	DataOut <= temp after 5 ns;

end Behavioral;

